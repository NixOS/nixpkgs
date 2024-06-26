{
  lib,
  stdenv,
  rebar3,
}:

{
  name,
  version,
  sha256,
  src,
  meta ? { },
}:

stdenv.mkDerivation ({
  pname = "rebar-deps-${name}";
  inherit version;

  dontUnpack = true;
  dontConfigure = true;
  dontFixup = true;

  buildPhase = ''
    cp -r ${src} src
    chmod -R u+w src
    cd src
    HOME='.' DEBUG=1 ${rebar3}/bin/rebar3 get-deps
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/_checkouts"
    for i in ./_build/default/lib/* ; do
       echo "$i"
       cp -R "$i" "$out/_checkouts"
    done
    runHook postInstall
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  impureEnvVars = lib.fetchers.proxyImpureEnvVars;
  inherit meta;
})
