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
  version = "1.0.11";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mcaulifn";
    repo = "solcast";
    rev = "v${version}";
    hash = "sha256-iK3WCpl7K/PUccNkOQK7q4k7JjwHAEydU47c8tb4wvc=";
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
