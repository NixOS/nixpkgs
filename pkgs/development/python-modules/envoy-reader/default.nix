{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  envoy-utils,
  fetchFromGitHub,
  setuptools,
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
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jesserizzo";
    repo = "envoy_reader";
    rev = version;
    hash = "sha256-aIpZ4ln4L57HwK8H0FqsyNnXosnAp3ingrJI6/MPS90=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  pythonRelaxDeps = [ "pyjwt" ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner>=5.2" ""
  '';

  pythonImportsCheck = [ "envoy_reader" ];

  meta = with lib; {
    description = "Python module to read from Enphase Envoy units";
    homepage = "https://github.com/jesserizzo/envoy_reader";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
