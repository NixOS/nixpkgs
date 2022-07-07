{ lib
, buildPythonPackage
, fetchPypi
, flask
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-talisman";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IF0958Xs+tZnyEEj9fvlgLH2jNmhsFjXNTzANI4Vsb8=";
  };

  buildInputs = [
    flask
  ];

  propagatedBuildInputs = [
    six
  ];

  nativeBuildInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "HTTP security headers for Flask";
    homepage = "https://github.com/wntrblm/flask-talisman";
    license = licenses.asl20;
    maintainers = [ lib.maintainers.symphorien ];
  };
}
