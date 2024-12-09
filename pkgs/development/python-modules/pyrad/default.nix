{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  unittestCheckHook,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pyrad";
  version = "2.4-unstable-2024-07-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyradius";
    repo = pname;
    rev = "f42a57cb0e80de42949810057d36df7c4a6b5146";
    hash = "sha256-5SPVeBL1oMZ/XXgKch2Hbk6BRU24HlVl4oXZ2agF1h8=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "pyrad" ];

  meta = {
    description = "Python RADIUS Implementation";
    homepage = "https://github.com/pyradius/pyrad";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ drawbu ];
  };
}
