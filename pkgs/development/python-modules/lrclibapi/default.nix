{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  requests,
  vcrpy,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "lrclibapi";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dr-Blank";
    repo = "lrclibapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K5wO3BexftnWe48loaW8TjySQvh2X+X3GSmG5qg+BGc=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    requests
  ];

  pythonImportsCheck = [
    "lrclib"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
  ];

  meta = {
    homepage = "https://github.com/Dr-Blank/lrclibapi";
    changelog = "https://github.com/Dr-Blank/lrclibapi/releases/tag/v${finalAttrs.version}";
    description = "Python wrapper for downloading synced lyrics from the lrclib.net api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DataHearth ];
  };
})
