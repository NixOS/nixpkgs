{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "httmock";
  version = "1.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "patrys";
    repo = "httmock";
    rev = finalAttrs.version;
    hash = "sha256-yid4vh1do0zqVzd1VV7gc+Du4VPrkeGFsDHqNbHL28I=";
  };

  nativeCheckInputs = [
    requests
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests.py" ];

  pythonImportsCheck = [ "httmock" ];

  meta = {
    description = "Mocking library for requests";
    homepage = "https://github.com/patrys/httmock";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nyanloutre ];
  };
})
