{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sqlalchemy,
  requests,
  python-dateutil,
  tqdm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "idbutils";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tcgoetz";
    repo = "utilities";
    tag = version;
    hash = "sha256-niscY7sURrJ7YcPKbI6ByU03po6Hfxm0gHbvmDa6TgM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    sqlalchemy
    requests
    python-dateutil
    tqdm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "idbutils" ];

  meta = {
    description = "Python utilities useful for database and internal apps";
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/tcgoetz/utilities";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
