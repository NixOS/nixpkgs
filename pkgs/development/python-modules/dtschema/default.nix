{ lib
, buildPythonPackage
, fetchFromGitHub
, jsonschema
, pythonOlder
, rfc3987
, ruamel-yaml
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dtschema";
  version = "2022.01";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "devicetree-org";
    repo = "dt-schema";
    rev = "refs/tags/v${version}";
    hash = "sha256-wwlXIM/eO3dII/qQpkAGLT3/15rBLi7ZiNtqYFf7Li4=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    jsonschema
    rfc3987
    ruamel-yaml
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "dtschema"
  ];

  meta = with lib; {
    description = "Tooling for devicetree validation using YAML and jsonschema";
    homepage = "https://github.com/devicetree-org/dt-schema/";
    changelog = "https://github.com/devicetree-org/dt-schema/releases/tag/v${version}";
    license = with licenses; [ bsd2 /* or */ gpl2Only ];
    maintainers = with maintainers; [ sorki ];
  };
}

