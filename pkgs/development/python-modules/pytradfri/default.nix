{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  aiocoap,
  dtlssocket,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytradfri";
  version = "13.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "pytradfri";
    tag = version;
    hash = "sha256-CWv3ebDulZuiFP+nJ2Xr7U/HTDFTqA9VYC0USLkpWR0=";
  };

  patches = [
    (fetchpatch2 {
      name = "pydantic2-compat.patch";
      url = "https://github.com/home-assistant-libs/pytradfri/commit/ecd099837a0b4538a56301af6260fddde77fbbb1.patch";
      excludes = [ "requirements.txt" ];
      hash = "sha256-QsvBTB9evKyE1fcfDaB0SN21kHmNmLgGPs3GJHHsMJc=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ pydantic ];

  optional-dependencies = {
    async = [
      aiocoap
      dtlssocket
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.async;

  pythonImportsCheck = [ "pytradfri" ];

  meta = with lib; {
    description = "Python package to communicate with the IKEA Trådfri ZigBee Gateway";
    homepage = "https://github.com/home-assistant-libs/pytradfri";
    changelog = "https://github.com/home-assistant-libs/pytradfri/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
