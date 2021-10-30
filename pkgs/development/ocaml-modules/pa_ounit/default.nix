{ lib, buildOcaml, ocaml, fetchFromGitHub, ounit }:

if lib.versionAtLeast ocaml.version "4.06"
then throw "pa_ounit is not available for OCaml ${ocaml.version}"
else

buildOcaml rec {
  pname = "pa_ounit";
  version = "113.00.00";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "pa_ounit";
    rev = version;
    sha256 = "sha256-zzXN+mSJtlnQ3e1QoEukCiyfDEoe8cBdkAQ3U1dkvEk=";
  };

  propagatedBuildInputs = [ ounit ];

  meta = with lib; {
    homepage = "https://github.com/janestreet/pa_ounit";
    description = "OCaml inline testing";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
