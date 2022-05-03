{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, shapely
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "preprocess-cancellation";
  version = "0.2.0";
  disabled = pythonOlder "3.6"; # >= 3.6
  format = "pyproject";

  # No tests in PyPI
  src = fetchFromGitHub {
    owner = "kageurufu";
    repo = "cancelobject-preprocessor";
    rev = version;
    hash = "sha256-mn3/etXA5dkL+IsyxwD4/XjU/t4/roYFVyqQxlLOoOI=";
  };

  patches = [
    ./pep-621.patch
  ];

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
  ];

  propagatedBuildInputs = [
    shapely
  ];

  checkInputs = [
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
