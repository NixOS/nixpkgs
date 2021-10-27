{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, setuptools-scm
, pydantic
, typeguard
, mock
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pygls";
  version = "0.11.2";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "openlawlibrary";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zgQ5m198HMyFFrASSYCzn0EDLLeVy2j4LD0rEyEgahQ=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;
  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    pydantic
    typeguard
  ];

  checkInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  # Fixes hanging tests on Darwin
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pygls" ];

  meta = with lib; {
    description = "Pythonic generic implementation of the Language Server Protocol";
    homepage = "https://github.com/openlawlibrary/pygls";
    license = licenses.asl20;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
