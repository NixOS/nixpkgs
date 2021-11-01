{ lib
, buildPythonPackage
, fetchPypi
, flask
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-talisman";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11gjgqkpj2yqydb0pfhjyx56iy4l9szgz33vg5d7bw8vqp02wl2x";
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
