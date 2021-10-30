{ lib, buildOcaml, ocaml, fetchFromGitHub, type_conv }:

if lib.versionAtLeast ocaml.version "4.06"
then throw "variantslib-109.15.03 is not available for OCaml ${ocaml.version}"
else

buildOcaml rec {
  name = "variantslib";
  version = "109.15.03";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "variantslib";
    rev = version;
    sha256 = "sha256-pz3i3od2CqKSrm7uTQ2jdidFFwx7m7g1QuG4UdLk01k=";
  };

  propagatedBuildInputs = [ type_conv ];

  meta = with lib; {
    homepage = "https://github.com/janestreet/variantslib";
    description = "OCaml variants as first class values";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
