{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  shapely,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "preprocess-cancellation";
  version = "0.2.1";
  pyproject = true;

  # No tests in PyPI
  src = fetchFromGitHub {
    owner = "kageurufu";
    repo = "cancelobject-preprocessor";
    tag = version;
    hash = "sha256-MJ4mwOFswLYHhg2LNZ+/ZwDvSjoxElVxlaWjArHV2NY=";
  };

  postPatch = ''
    sed -i "/^addopts/d" pyproject.toml

    cat >> pyproject.toml << EOF
    [build-system]
    requires = ["poetry-core"]
    build-backend = "poetry.core.masonry.api"
    EOF
  '';

  build-system = [
    poetry-core
  ];

  optional-dependencies = {
    shapely = [ shapely ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "preprocess_cancellation" ];

  meta = {
    description = "Klipper GCode Preprocessor for Object Cancellation";
    homepage = "https://github.com/kageurufu/cancelobject-preprocessor";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zhaofengli ];
  };
}
