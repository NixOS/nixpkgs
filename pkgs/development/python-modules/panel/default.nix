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
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04w8jjlf7yz3k84xnacahczc9mmddqyp756rj3n8hclks9c1ww40";
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
    homepage = http://pyviz.org;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
