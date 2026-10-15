{
  lib,
  fetchurl,
  buildDunePackage,
  io-page,
  mirage-block,
}:

buildDunePackage rec {
  pname = "mirage-block-ramdisk";
  version = "0.5";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-block-ramdisk/releases/download/${version}/mirage-block-ramdisk-${version}.tbz";
    hash = "sha256-zA6BT9VO/npbeoxescBOLeznUbfY3uLZWQigdoiW6K8=";
  };

  # Make compatible with cstruct 6.1.0
  postPatch = ''
    substituteInPlace src/ramdisk.ml --replace 'Cstruct.len' 'Cstruct.length'
  '';

  minimalOCamlVersion = "4.06";
  duneVersion = "3";

  propagatedBuildInputs = [
    io-page
    mirage-block
  ];

  doCheck = false;

  meta = {
    description = "In-memory BLOCK device for MirageOS";
    homepage = "https://github.com/mirage/mirage-block-ramdisk";
    license = lib.licenses.isc;
  };
}
