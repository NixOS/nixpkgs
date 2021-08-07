{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, pytest-asyncio
, pytest-raises
, pytest-runner
, pytestCheckHook
, respx
}:

buildPythonPackage rec {
  pname = "envoy-reader";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "jesserizzo";
    repo = "envoy_reader";
    rev = version;
    sha256 = "0jyrgm7dc6k66c94gadc69a6xsv2b48wn3b3rbpwgbssi5s7iiz6";
  };

  nativeBuildInputs = [
    pytest-runner
  ];

  propagatedBuildInputs = [
    httpx
  ];

  checkInputs = [
    pytest-raises
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "envoy_reader" ];

  meta = with lib; {
    description = "Python module to read from Enphase Envoy units";
    homepage = "https://github.com/jesserizzo/envoy_reader";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
