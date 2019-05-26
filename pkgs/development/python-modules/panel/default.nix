{ lib
, buildPythonPackage
, fetchPypi
, bokeh
, param
, pyviz-comms
, markdown
, pyct
, testpath
, pytest
, scipy
, plotly
, altair
, vega_datasets
, hvplot
}:

buildPythonPackage rec {
  pname = "panel";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21fc6729909dba4ba8c9a84b7fadd293322cc2594d15ac73b0f66a5ceffd1f98";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "testpath<0.4" "testpath"
  '';

  propagatedBuildInputs = [
    bokeh
    param
    pyviz-comms
    markdown
    pyct
    testpath
  ];

  # infinite recursion in test dependencies (hvplot)
  doCheck = false;

  meta = with lib; {
    description = "A high level dashboarding library for python visualization libraries";
    homepage = http://pyviz.org;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
