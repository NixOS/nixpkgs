{ lib, fetchurl, buildDunePackage, io-page, io-page-unix, mirage-block, alcotest
, mirage-block-combinators }:

buildDunePackage rec {
  pname = "mirage-block-ramdisk";
  version = "0.5";

  useDune2 = true;

  src = fetchurl {
    url =
      "https://github.com/mirage/mirage-block-ramdisk/releases/download/${version}/mirage-block-ramdisk-${version}.tbz";
    sha256 = "cc0e814fd54efe7a5b7a8c5eb1c04e2dece751b7d8dee2d95908a0768896e8af";
  };

  # Make tests compatible with alcotest 1.4.0
  postPatch = ''
    substituteInPlace test/tests.ml --replace 'Fmt.kstrf Alcotest.fail' 'Fmt.kstrf (fun s -> Alcotest.fail s)'
  '';

  minimumOCamlVersion = "4.06";

  propagatedBuildInputs = [ io-page mirage-block ];

  doCheck = true;
  checkInputs = [ alcotest io-page-unix mirage-block-combinators ];

  meta = with lib; {
    description = "In-memory BLOCK device for MirageOS";
    homepage = "https://github.com/mirage/mirage-block-ramdisk";
    license = licenses.isc;
    maintainers = with maintainers; [ ehmry ];
  };
}
