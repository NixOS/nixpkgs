{ lib, buildPythonPackage, fetchPypi, flask, webassets, flask_script, nose }:

buildPythonPackage rec {
  pname = "Flask-Assets";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dfdea35e40744d46aada72831f7613d67bf38e8b20ccaaa9e91fdc37aa3b8c2";
  };

  patchPhase = ''
    substituteInPlace tests/test_integration.py --replace 'static_path=' 'static_url_path='
    substituteInPlace tests/test_integration.py --replace "static_folder = '/'" "static_folder = '/x'"
    substituteInPlace tests/test_integration.py --replace "'/foo'" "'/x/foo'"
  '';

  propagatedBuildInputs = [ flask webassets flask_script nose ];

  meta = with lib; {
    homepage = "https://github.com/miracle2k/flask-assets";
    description = "Asset management for Flask, to compress and merge CSS and Javascript files";
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
