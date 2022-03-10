{ lib
, bleach
, buildPythonPackage
, cmarkgfm
, docutils
, fetchPypi
, mock
, pygments
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "readme-renderer";
  version = "33.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "readme_renderer";
    inherit version;
    sha256 = "sha256-47U7yEvWrwVOTMH+NWfcGuGfVUE0IhBDo/jGdOIiCds=";
  };

  propagatedBuildInputs = [
    bleach
    cmarkgfm
    docutils
    pygments
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "cmarkgfm>=0.5.0,<0.7.0" "cmarkgfm>=0.5.0,<1"
  '';

  disabledTests = [
    # https://github.com/pypa/readme_renderer/issues/221
    "test_GFM_"
  ];

  pythonImportsCheck = [
    "readme_renderer"
  ];

  meta = with lib; {
    description = "Python library for rendering readme descriptions";
    homepage = "https://github.com/pypa/readme_renderer";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
