{ lib, stdenv, fetchurl }:

{ pkg
, version
, sha256
, meta ? { }
}:

stdenv.mkDerivation ({
  pname = "hex-source-${pkg}";
  inherit version;
  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  src = fetchurl {
    url = "https://repo.hex.pm/tarballs/${pkg}-${version}.tar";
    inherit sha256;
  };

  unpackCmd = ''
    tar -xf $curSrc contents.tar.gz CHECKSUM metadata.config
    mkdir contents
    tar -C contents -xzf contents.tar.gz
    mv metadata.config contents/hex_metadata.config

    # To make the extracted hex tarballs appear legitimate to mix, we need to
    # make sure they contain not just the contents of contents.tar.gz but also
    # a .hex file with some lock metadata.
    # We use an old version of .hex file per hex's mix_task_test.exs since it
    # is just plain-text instead of an encoded format.
    # See: https://github.com/hexpm/hex/blob/main/test/hex/mix_task_test.exs#L410
    echo -n "${pkg},${version},$(cat CHECKSUM | tr '[:upper:]' '[:lower:]'),hexpm" > contents/.hex
  '';

  installPhase = ''
    runHook preInstall
    mkdir "$out"
    cp -Hrt "$out" .
    success=1
    runHook postInstall
  '';

  inherit meta;
})
