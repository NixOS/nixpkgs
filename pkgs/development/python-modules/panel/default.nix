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
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b86a827f24dcfd1b6d821836e691fca7aab21b79a293031297f83cf2f8d6cef";
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
