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
  version = "0.30.dev0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb612994b7f364e872301b4569b544648e95e587d803284ddb5610efc8f2170f";
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
