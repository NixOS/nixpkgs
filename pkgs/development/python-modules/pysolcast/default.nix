{ lib
, buildPythonPackage
, fetchFromGitHub
, isodate
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, responses
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pysolcast";
  version = "1.0.12";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mcaulifn";
    repo = "solcast";
    rev = "v${version}";
    hash = "sha256-azcEbv/4M3UqRyV30yld+6pWbSxbGXiJJHWMDL4xgOM=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    isodate
    pyyaml
    requests
  ];

  checkInputs = [
    pytestCheckHook
    responses
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

  pythonImportsCheck = [
    "pysolcast"
  ];

  meta = with lib; {
    description = "Python library for interacting with the Solcast API";
    homepage = "https://github.com/mcaulifn/solcast";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
