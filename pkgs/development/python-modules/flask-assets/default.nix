{ lib, buildPythonPackage, fetchPypi, flask, webassets, flask_script, nose }:

buildPythonPackage rec {
  pname = "Flask-Assets";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hmqldxc7zciksmcl35jx0wbyrrxc7vk2a57mmmd8i07whsymz8x";
  };

  patchPhase = ''
    substituteInPlace tests/test_integration.py --replace 'static_path=' 'static_url_path='
  '';

  propagatedBuildInputs = [ flask webassets flask_script nose ];

  meta = with lib; {
    homepage = "https://github.com/miracle2k/flask-assets";
    description = "Asset management for Flask, to compress and merge CSS and Javascript files";
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
