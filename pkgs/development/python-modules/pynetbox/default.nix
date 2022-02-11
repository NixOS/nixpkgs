{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, requests
, six
, pytestCheckHook
, pyyaml
}:

buildPythonPackage rec {
  pname = "pynetbox";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vgknnFnmRLIpBLdv1iFGkuql2NOLurOgF2CDKoo8WGg=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    requests
    six
  ];

  checkInputs = [
    pytestCheckHook
    pyyaml
  ];

  disabledTestPaths = [
    # requires docker for integration test
    "tests/integration"
  ];

  meta = with lib; {
    description = "API client library for Netbox";
    homepage = "https://github.com/netbox-community/pynetbox";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
