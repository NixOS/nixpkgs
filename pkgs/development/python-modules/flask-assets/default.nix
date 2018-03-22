{ lib, buildPythonPackage, fetchurl, flask, webassets, flask_script, nose }:

buildPythonPackage rec {
  name = "Flask-Assets-${version}";
  version = "0.12";

  src = fetchurl {
    url = "mirror://pypi/F/Flask-Assets/${name}.tar.gz";
    sha256 = "0ivqsihk994rxw58vdgzrx4d77d7lpzjm4qxb38hjdgvi5xm4cb0";
  };

  propagatedBuildInputs = [ flask webassets flask_script nose ];

  meta = with lib; {
    homepage = http://github.com/miracle2k/flask-assets;
    description = "Asset management for Flask, to compress and merge CSS and Javascript files";
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
