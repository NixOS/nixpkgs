{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  poetry-core,
  django,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "django-split-settings";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wemake-services";
    repo = "django-split-settings";
    rev = version;
    hash = "sha256-Bk2/DU+K524mCUvteWT0fIQH5ZgeMHiufMTF+dJYVtc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry.masonry" "poetry.core.masonry"
  '';

  build-system = [ poetry-core ];

  dependencies = [ django ];

  pythonImportsCheck = [ "split_settings" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "Organize Django settings into multiple files and directories";
    homepage = "https://github.com/wemake-services/django-split-settings";
    maintainers = with lib.maintainers; [ sikmir ];
    license = lib.licenses.bsd3;
  };
}
