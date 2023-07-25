{ lib
, buildPythonPackage
, fetchFromGitHub
, jsonschema
, pythonOlder
, rfc3987
, ruamel-yaml
, setuptools-scm
, libfdt
}:

buildPythonPackage rec {
  pname = "dtschema";
  version = "2023.04";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "devicetree-org";
    repo = "dt-schema";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-w9TsRdiDTdExft7rdb2hYcvxP6hxOFZKI3hITiNSwgw=";
  };

  patches = [
    # Change name of pylibfdt to libfdt
    ./fix_libfdt_name.patch
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    jsonschema
    rfc3987
    ruamel-yaml
    libfdt
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

