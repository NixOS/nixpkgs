{ lib, stdenv, fetchurl }:

{ pkg, version, sha256
, meta ? {}
}:

with lib;

stdenv.mkDerivation ({
  name = "hex-source-${pkg}-${version}";

  src = fetchurl {
    url = "https://repo.hex.pm/tarballs/${pkg}-${version}.tar";
    inherit sha256;
  };

  unpackCmd = ''
    tar -xf $curSrc contents.tar.gz
    mkdir contents
    tar -C contents -xzf contents.tar.gz
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir "$out"
    cp -Hrt "$out" .
    success=1
    runHook postInstall
  '';

  inherit meta;
})
