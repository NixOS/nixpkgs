{ lib
, buildPythonPackage
, fetchPypi
, bokeh
, param
, pyviz-comms
, markdown
, pyct
, testpath
}:

buildPythonPackage rec {
  pname = "panel";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "71d446f469b424cb190bc896e78d0415b2bbebf17c6e5b024ed1a73b4448f8f4";
  };

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
    homepage = https://pyviz.org;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
