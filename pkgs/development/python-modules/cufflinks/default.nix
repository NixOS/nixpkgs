{
  lib,
  buildPythonPackage,
  fetchPypi,
  colorlover,
  ipython,
  ipywidgets,
  numpy,
  pandas,
  plotly,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "cufflinks";
  version = "0.17.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SMGzQG3AMABBIZZkie68VRjOpw/U4/FjebSRMoUBpkQ=";
  };

  # replace duplicated pandas method
  # https://github.com/santosjorge/cufflinks/pull/249#issuecomment-1759619149
  postPatch = ''
    substituteInPlace tests.py \
      --replace-fail "from nose.tools import assert_equals" "def assert_equals(x, y): assert x == y" \
      --replace-fail "df.ix" "df.loc"
  '';

  build-system = [ setuptools ];

  dependencies = [
    colorlover
    ipython
    ipywidgets
    numpy
    pandas
    plotly
    six
  ];

  pythonImportsCheck = [ "cufflinks" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests.py" ];

  meta = with lib; {
    description = "Productivity Tools for Plotly + Pandas";
    homepage = "https://github.com/santosjorge/cufflinks";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
