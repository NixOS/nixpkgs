{ ruby, fetchurl, rake, rubygemsFun, makeWrapper, lib, git }:

{ name
, namePrefix ? "ruby${ruby.majorVersion}" + "-"
, buildInputs ? []
, doCheck ? false
, doGitPrecheckHack ? false
, meta ? {}
, gemPath ? []
, testTask ? "test"
, preCheck ? ""
, postCheck ? ""
, ...} @ attrs:

let
  rubygems = rubygemsFun ruby;
  depsPath = lib.concatStringsSep ":" (map (g: "${g}/${ruby.gemPath}") gemPath);

in ruby.stdenv.mkDerivation (attrs // {
  inherit doCheck;

  buildInputs = [ rubygems makeWrapper git ] ++ buildInputs;

  name = namePrefix + name;

  src = if attrs ? src
    then attrs.src
    else fetchurl {
      url = "http://rubygems.org/downloads/${attrs.name}.gem";
      inherit (attrs) sha256;
    };

  unpackPhase = ''
    gem unpack $src --target=gem-build
  '';

  dontBuild = true;

  preCheckGit = ruby.stdenv.lib.optionalString doGitPrecheckHack ''
    ${git}/bin/git init
    ${git}/bin/git add .
  '';

  preCheck = ''
    cd gem-build/*
    OLD_PATH="$GEM_PATH"
    export GEM_PATH="${depsPath}"
  '' + preCheck;

  postCheck = ''
    GEM_PATH="$OLD_PATH"
  '' + postCheck;

  checkPhase =
    if attrs ? checkPhase then attrs.checkPhase
    else ''
      runHook preCheckGit
      runHook preCheck
      test -f Rakefile && ${rake}/bin/rake ${testTask} -v
      runHook postCheck
    '';

  installPhase = ''
    GEM_PATH="${depsPath}" GEM_HOME=$out/${ruby.gemPath} \
      gem install -p http://nodtd.invalid \
      --build-root / -n "$out/bin" "$src" $gemFlags -- $buildFlags
    rm -frv $out/${ruby.gemPath}/cache # don't keep the .gem file here

    for prog in $out/bin/*; do
      wrapProgram "$prog" \
        --prefix GEM_PATH : "$out/${ruby.gemPath}:${depsPath}" \
        --prefix RUBYLIB : "${rubygems}/lib" \
        --set RUBYOPT rubygems \
        $extraWrapperFlags ''${extraWrapperFlagsArray[@]}
    done

    for prog in $out/gems/*/bin/*; do
      [[ -e "$out/bin/$(basename $prog)" ]]
    done

    # looks like useless files which break build repeatability and consume space
    rm $out/${ruby.gemPath}/doc/*/*/created.rid || true
    rm $out/${ruby.gemPath}/gems/*/ext/*/mkmf.log || true

    runHook postInstall
  '';

  propagatedBuildInputs = gemPath;
  propagatedUserEnvPkgs = gemPath;

  passthru.isRubyGem = true;
  inherit meta;
})
