{ lib, buildDunePackage, fetchurl
, fmt, mirage-flow, result, rresult, cstruct, logs, ke
, alcotest, alcotest-lwt, bigstringaf, bigarray-compat
}:

buildDunePackage rec {
  pname = "mimic";
  version = "0.0.2";

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-git/releases/download/${pname}-v${version}/${pname}-${pname}-v${version}.tbz";
    sha256 = "3ad5af3caa1120ecfdf022de41ba5be8edfbf50270fc99238b82d3d2d6e7c317";
  };

  # don't install changelogs for other packages
  postPatch = ''
    rm -f CHANGES.md CHANGES.carton.md
  '';

  propagatedBuildInputs = [
    fmt
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
