{ lib, fetchurl, buildDunePackage, ppxlib, ppx_repr, logs, fmt, bisect_ppx }:

buildDunePackage rec {
  pname = "ppx_irmin";
  version = "3.3.2";

  src = fetchurl {
    url = "https://github.com/mirage/irmin/releases/download/${version}/irmin-${version}.tbz";
    sha256 = "1zx6w7y5p0ad68lb1940f6bchy5xs8r1qdfbavp5xcy27p67xa4m";
  };

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  propagatedBuildInputs = [
    ppx_repr
    ppxlib
    logs
  ];

  doCheck = true;

  checkInputs = [
    fmt
  ];

  meta = {
    homepage = "https://irmin.org/";
    description = "PPX deriver for Irmin generics";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl sternenseemann ];
  };
}
