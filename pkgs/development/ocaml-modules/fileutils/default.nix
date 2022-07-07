{ lib, fetchurl, buildDunePackage, stdlib-shims, ounit }:

buildDunePackage rec {
  pname = "fileutils";
  version = "0.6.3";

  src = fetchurl {
    url = "https://github.com/gildor478/ocaml-fileutils/releases/download/v${version}/fileutils-v${version}.tbz";
    sha256 = "0qhlhc7fzcq0yfg1wyszsi0gyc4w9hyzmfv84aq9wc79i3283xgg";
  };

  minimumOCamlVersion = "4.03";
  useDune2 = true;

  propagatedBuildInputs = [
    stdlib-shims
  ];

  checkInputs = [
    ounit
  ];
  doCheck = true;

  meta = with lib; {
    description = "OCaml API to manipulate real files (POSIX like) and filenames";
    homepage = "https://github.com/gildor478/ocaml-fileutils";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ vbgl ];
  };
}
