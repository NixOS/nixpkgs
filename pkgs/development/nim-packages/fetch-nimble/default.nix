{ lib, makeOverridable, stdenv, gitMinimal, nim, cacert }:

makeOverridable (

  { pname, version, hash ? lib.fakeHash,

  meta ? { }, passthru ? { }, preferLocalBuild ? true }:
  stdenv.mkDerivation {
    inherit version meta passthru preferLocalBuild;
    pname = pname + "-src";
    pkgname = pname;
    builder = ./builder.sh;
    nativeBuildInputs = [ gitMinimal nim ];
    outputHash = hash;
    outputHashAlgo = null;
    outputHashMode = "recursive";
    impureEnvVars = lib.fetchers.proxyImpureEnvVars
      ++ [ "GIT_PROXY_COMMAND" "SOCKS_SERVER" ];
    GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  })
