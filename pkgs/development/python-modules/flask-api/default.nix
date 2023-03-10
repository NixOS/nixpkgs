{ lib, buildPythonPackage, pythonOlder, fetchPypi, flask, markdown }:

buildPythonPackage rec {
  pname = "Flask-API";
  version = "3.0.post1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1khw0f9ywn1mbdlcl0xspacqjz2pxq00m4g73bksbc1k0i88j61k";
  };

  propagatedBuildInputs = [ flask markdown ];

  meta = with lib; {
    homepage = "https://github.com/miracle2k/flask-assets";
    description = "Browsable web APIs for Flask";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
