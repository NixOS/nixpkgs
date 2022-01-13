{ lib, fetchFromGitHub, buildOcaml}:

buildOcaml rec {
  minimumSupportedOcamlVersion = "4.02";

  pname = "type_conv";
  version = "113.00.02";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "type_conv";
    rev = version;
    sha256 = "sha256-HzH0hnceCQ2kDRATjl+tfKk3XSBDsGnPzVUGYpDQUmU=";
  };

  meta = {
    homepage = "https://github.com/janestreet/type_conv/";
    description = "Support library for preprocessor type conversions";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ maggesi ericbmerritt ];
  };
}
