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
    sha256 = "cc0e814fd54efe7a5b7a8c5eb1c04e2dece751b7d8dee2d95908a0768896e8af";
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

  meta = with lib; {
    description = "In-memory BLOCK device for MirageOS";
    homepage = "https://github.com/mirage/mirage-block-ramdisk";
    license = licenses.isc;
  };
}
