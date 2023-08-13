{ lib
, buildPythonPackage
, fetchPypi
, flit
, jinja2
, ruamel-yaml
, matplotlib
, pandas
, pandoc
, pygments
, blessings
, curio
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "reportengine";
  version = "0.31";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jrt+ml8o1PUidV1bY0hCyNgcPaVTBloW574/i5Pl7iE=";
  };

  nativeBuildInputs = [ flit ];

  propagatedBuildInputs = [
    jinja2
    ruamel-yaml
    matplotlib
    pandas
    pygments
    blessings
    curio
  ];

  nativeCheckInputs = [
    hypothesis
    pandoc
    pytestCheckHook
  ];

  pythonImportsCheck = [ "reportengine" ];

  meta = with lib; {
    description = "A framework for declarative data analysis";
    homepage = "https://github.com/NNPDF/reportengine/";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ veprbl ];
  };
}
