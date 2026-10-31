{
  lib,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  mock,
  pytest-asyncio,
  pytest-timeout,
  pytest-vcr,
  pytestCheckHook,
  requests,
  requests-mock,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "rxv";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wuub";
    repo = "rxv";
    rev = "v${version}";
    hash = "sha256-6PsUcGdB1kWxShIPK1xqXE/MNq0h7bdsqLI8tz61jUo=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    defusedxml
    requests
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytest-timeout
    pytest-vcr
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "rxv" ];

  meta = {
    description = "Python library for communicate with Yamaha RX-Vxxx receivers";
    homepage = "https://github.com/wuub/rxv";
    license = lib.licenses.mit;
  };
}
