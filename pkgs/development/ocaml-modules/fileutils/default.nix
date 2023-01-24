{ lib, fetchurl, ocaml, buildDunePackage, seq, stdlib-shims, ounit2 }:

buildDunePackage rec {
  pname = "fileutils";
  version = "0.6.4";

  src = fetchurl {
    url = "https://github.com/gildor478/ocaml-fileutils/releases/download/v${version}/fileutils-${version}.tbz";
    hash = "sha256-enu2vGo2tuvawrTkap6bENNmxaLUQXpfHWih+7oKRF8=";
  };

  minimalOCamlVersion = "4.03";

  propagatedBuildInputs = [
    seq
    stdlib-shims
  ];

  nativeCheckInputs = [
    ounit2
  ];
  doCheck = lib.versionAtLeast ocaml.version "4.04";

  meta = with lib; {
    description = "OCaml API to manipulate real files (POSIX like) and filenames";
    homepage = "https://github.com/gildor478/ocaml-fileutils";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ vbgl ];
  };
}
