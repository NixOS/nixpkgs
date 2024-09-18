{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  aiocoap,
  dtlssocket,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytradfri";
  version = "13.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pytradfri";
    rev = "refs/tags/${version}";
    hash = "sha256-CWv3ebDulZuiFP+nJ2Xr7U/HTDFTqA9VYC0USLkpWR0=";
  };

  propagatedBuildInputs = [ pydantic ];

  passthru.optional-dependencies = {
    async = [
      aiocoap
      dtlssocket
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ passthru.optional-dependencies.async;

  pythonImportsCheck = [ "pytradfri" ];

  meta = with lib; {
    description = "Python package to communicate with the IKEA Trådfri ZigBee Gateway";
    homepage = "https://github.com/home-assistant-libs/pytradfri";
    changelog = "https://github.com/home-assistant-libs/pytradfri/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
    # https://github.com/home-assistant-libs/pytradfri/issues/720
    broken = versionAtLeast pydantic.version "2";
  };
}
