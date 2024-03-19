{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, setuptools
, shapely
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "preprocess-cancellation";
  version = "0.2.1";
  disabled = pythonOlder "3.6"; # >= 3.6
  format = "pyproject";

  # No tests in PyPI
  src = fetchFromGitHub {
    owner = "kageurufu";
    repo = "cancelobject-preprocessor";
    rev = "refs/tags/${version}";
    hash = "sha256-MJ4mwOFswLYHhg2LNZ+/ZwDvSjoxElVxlaWjArHV2NY=";
  };

  postPatch = ''
    sed -i "/^addopts/d" pyproject.toml

    # setuptools 61 compatibility
    # error: Multiple top-level packages discovered in a flat-layout: ['STLs', 'GCode'].
    mkdir tests
    mv GCode STLs test_* tests
    substituteInPlace tests/test_preprocessor.py \
      --replace "./GCode" "./tests/GCode"
    substituteInPlace tests/test_preprocessor_with_shapely.py \
      --replace "./GCode" "./tests/GCode"
  '';

  nativeBuildInputs = [
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [
    shapely
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "preprocess_cancellation" ];

  meta = with lib; {
    description = "Klipper GCode Preprocessor for Object Cancellation";
    homepage = "https://github.com/kageurufu/cancelobject-preprocessor";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
