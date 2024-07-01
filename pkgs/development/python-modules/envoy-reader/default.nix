{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  envoy-utils,
  fetchFromGitHub,
  httpx,
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
  pytest-raises,
  pythonOlder,
  respx,
}:

buildPythonPackage rec {
  pname = "envoy-reader";
  version = "0.21.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jesserizzo";
    repo = "envoy_reader";
    rev = version;
    hash = "sha256-aIpZ4ln4L57HwK8H0FqsyNnXosnAp3ingrJI6/MPS90=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    envoy-utils
    httpx
    pyjwt
  ];

  nativeCheckInputs = [
    pytest-raises
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner>=5.2" "" \
      --replace "pyjwt==2.1.0" "pyjwt>=2.1.0"
  '';

  pythonImportsCheck = [ "envoy_reader" ];

  meta = with lib; {
    description = "Python module to read from Enphase Envoy units";
    homepage = "https://github.com/jesserizzo/envoy_reader";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
