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
  version = "1.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mcaulifn";
    repo = "solcast";
    rev = "v${version}";
    sha256 = "J4D7W89Qz1Nv4DeqOmHVAWfmThlY5puBjSClRkfwhVw=";
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
    # No license statement present
    # https://github.com/mcaulifn/solcast/issues/70
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ fab ];
  };
}
