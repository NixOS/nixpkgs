{ ruby, fetchurl, rake, rubygemsFun, makeWrapper, lib, git }:

{ name
, namePrefix ? "ruby${ruby.majorVersion}" + "-"
, buildInputs ? []
, doCheck ? false # TODO: fix this
, dontBuild ? true
, meta ? {}
, gemPath ? []
, testTask ? "test"
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
    if test -d $src; then
      cd $src
    else
      gem unpack $src --target=gem-build
      cd gem-build/*
    fi
  '';

  checkPhase = ''
    runHook preCheck
    ${attrs.checkPhase or "${rake}/bin/rake spec"}
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    GEM_HOME=$out/${ruby.gemPath} \
      gem install -p http://nodtd.invalid \
      --build-root / -n "$out/bin" "$src" $gemFlags -- $buildFlags
    rm -frv $out/${ruby.gemPath}/cache # don't keep the .gem file here

    for prog in $out/bin/*; do
      wrapProgram "$prog" \
        --prefix GEM_PATH : "$out/${ruby.gemPath}:$GEM_PATH" \
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

    mkdir -p $out/nix-support

    cat > $out/nix-support/setup-hook <<EOF
    if [[ "$GEM_PATH" != *$out/${ruby.gemPath}* ]]; then
      addToSearchPath GEM_PATH $out/${ruby.gemPath}
    fi
    EOF

    runHook postInstall
  '';

  propagatedBuildInputs = gemPath;
  propagatedUserEnvPkgs = gemPath;

  passthru.isRubyGem = true;
  inherit meta;
})
