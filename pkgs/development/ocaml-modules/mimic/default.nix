{ lib, buildDunePackage, fetchurl
, fmt, mirage-flow, result, rresult, cstruct, logs, ke, lwt
, alcotest, alcotest-lwt, bigstringaf, bigarray-compat
}:

buildDunePackage rec {
  pname = "mimic";
  version = "0.0.4";

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/dinosaure/mimic/releases/download/${version}/mimic-${version}.tbz";
    sha256 = "sha256-1Wb2xufgGKp3FJ+FYjK45i9B5+HohdPX+w9Sw0ph5JY=";
  };

  propagatedBuildInputs = [
    fmt
    lwt
    mirage-flow
    result
    rresult
    logs
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    alcotest-lwt
    bigstringaf
    bigarray-compat
    cstruct
    ke
  ];

  meta = with lib; {
    description = "A simple protocol dispatcher";
    license = licenses.isc;
    homepage = "https://github.com/mirage/ocaml-git";
    maintainers = [ maintainers.sternenseemann ];
  };
}
