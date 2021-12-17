{ lib
, buildPythonPackage
, envoy-utils
, fetchFromGitHub
, httpx
, pytest-asyncio
, pytest-raises
, pytestCheckHook
, respx
}:

buildPythonPackage rec {
  pname = "envoy-reader";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "jesserizzo";
    repo = "envoy_reader";
    rev = version;
    sha256 = "sha256-nPB1Fvb1qwLHeFkXP2jXixD2ZGA09MtS1qXRhYGt0fM=";
  };

  propagatedBuildInputs = [
    envoy-utils
    httpx
  ];

  checkInputs = [
    pytest-raises
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner>=5.2" ""
  '';

  pythonImportsCheck = [ "envoy_reader" ];

  meta = with lib; {
    description = "Python module to read from Enphase Envoy units";
    homepage = "https://github.com/jesserizzo/envoy_reader";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
