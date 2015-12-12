{ stdenv, erlang, rebar3, openssl, libyaml, fetchurl }:

{ name, version, sha256
, hexPkg ? name
, buildInputs ? [], erlangDeps ? []
, postPatch ? ""
, compilePorts ? false
, ... }@attrs:

with stdenv.lib;

stdenv.mkDerivation (attrs // {
  name = "${name}-${version}";

  buildInputs = buildInputs ++ [ erlang rebar3 openssl libyaml ];

  postPatch = ''
    rm -f rebar rebar3
    if [ -e "src/${name}.app.src" ]; then
      sed -i -e 's/{ *vsn *,[^}]*}/{vsn, "${version}"}/' "src/${name}.app.src"
    fi

    # TODO: figure out how to provide 'pc' plugin hermetically
    ${if compilePorts then ''
    echo "{plugins, [pc]}.
    {provider_hooks,
    [{post,
     [{compile, {pc, compile}},
      {clean, {pc, clean}}]}]}." >> rebar.config
    '' else ''''}

    ${postPatch}
  '';

  unpackCmd = ''
    tar -xf $curSrc contents.tar.gz
    mkdir contents
    tar -C contents -xzf contents.tar.gz
  '';

  configurePhase = let
    getDeps = drv: [drv] ++ (map getDeps drv.erlangDeps);
    recursiveDeps = uniqList {
       inputList = flatten (map getDeps erlangDeps);
    };
  in ''
    runHook preConfigure
    mkdir -p _build/default/lib/
    ${concatMapStrings (dep: ''
      header "linking erlang dependency ${dep}"
      ln -s "${dep}" "_build/default/lib/${dep.packageName}"
      stopNest
    '') recursiveDeps}
    runHook postConfigure
  '';

  # TODO: figure out how to provide rebar3 a static registry snapshot to make
  # this hermetic
  buildPhase = ''
    runHook preBuild
    HOME=. rebar3 update
    HOME=. rebar3 compile
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir "$out"
    for reldir in src ebin priv include; do
      fd="_build/default/lib/${name}/$reldir"
      [ -d "$fd" ] || continue
      cp -Hrt "$out" "$fd"
      success=1
    done
    runHook postInstall
  '';

  src = fetchurl {
    url = "https://s3.amazonaws.com/s3.hex.pm/tarballs/${hexPkg}-${version}.tar";
    sha256 = sha256;
  };

  passthru = {
    packageName = name;
    inherit erlangDeps;
  };
})
