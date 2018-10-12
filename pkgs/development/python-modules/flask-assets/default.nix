{ lib, buildPythonPackage, fetchPypi, flask, webassets, flask_script, nose }:

buildPythonPackage rec {
  pname = "Flask-Assets";
  version = "0.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ivqsihk994rxw58vdgzrx4d77d7lpzjm4qxb38hjdgvi5xm4cb0";
  };

  patchPhase = ''
    substituteInPlace tests/test_integration.py --replace 'static_path=' 'static_url_path='
  '';

  propagatedBuildInputs = [ flask webassets flask_script nose ];

  meta = with lib; {
    homepage = https://github.com/miracle2k/flask-assets;
    description = "Asset management for Flask, to compress and merge CSS and Javascript files";
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
