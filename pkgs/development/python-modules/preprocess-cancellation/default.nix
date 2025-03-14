{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  shapely,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "preprocess-cancellation";
  version = "0.2.1";
  disabled = pythonOlder "3.6"; # >= 3.6
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

  meta = with lib; {
    description = "Klipper GCode Preprocessor for Object Cancellation";
    homepage = "https://github.com/kageurufu/cancelobject-preprocessor";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
