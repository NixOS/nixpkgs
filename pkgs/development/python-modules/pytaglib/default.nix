{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  taglib,
  cython,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytaglib";
  version = "3.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "supermihi";
    repo = "pytaglib";
    tag = "v${version}";
    hash = "sha256-K9K30NFBcmxlYDQQ4YUhGzaPNVmLt0/L0JDrCtyKwLA=";
  };

  buildInputs = [
    cython
    taglib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "taglib" ];

  meta = with lib; {
    description = "Python bindings for the Taglib audio metadata library";
    mainProgram = "pyprinttags";
    homepage = "https://github.com/supermihi/pytaglib";
    changelog = "https://github.com/supermihi/pytaglib/blob/${src.tag}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mrkkrp ];
  };
}
