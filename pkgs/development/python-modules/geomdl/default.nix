{
  lib
  , buildPythonPackage
  , pythonOlder
  , fetchFromGitHub
  , pytestCheckHook
  , pyparsing
  , numpy
  , matplotlib
  , plotly
}:

buildPythonPackage rec {
  version = "5.3.1";
  pname = "geomdl";

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "orbingol";
    repo = "NURBS-Python";
    rev = "v${version}";
    sha256 = "sha256-FboZ6wIvIvwo09+5ZL6skOYRwtDKta3Ywyisq24evfc=";
  };

  checkInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    "-W ignore::DeprecationWarning"
  ];

  propagatedBuildInputs = [
    numpy
    matplotlib
    plotly
  ];

  meta = with lib; {
    description = "A pure Python, self-contained, object-oriented B-Spline and NURBS spline library";
    homepage = "https://onurraufbingol.com/NURBS-Python/";
    license = licenses.mit;
    maintainers = with maintainers; [ marcus7070 ];
  };
}
