<<<<<<< HEAD
{ lib, buildPythonPackage, fetchPypi, flask, webassets, flask-script, nose }:

buildPythonPackage rec {
  pname = "flask-assets";
  version = "2.0";

  src = fetchPypi {
    pname = "Flask-Assets";
    inherit version;
    hash = "sha256-Hf3qNeQHRNRqracoMfdhPWe/OOiyDMqqnpH9w3qjuMI=";
=======
{ lib, buildPythonPackage, fetchPypi, flask, webassets, flask_script, nose }:

buildPythonPackage rec {
  pname = "Flask-Assets";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dfdea35e40744d46aada72831f7613d67bf38e8b20ccaaa9e91fdc37aa3b8c2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patchPhase = ''
    substituteInPlace tests/test_integration.py --replace 'static_path=' 'static_url_path='
    substituteInPlace tests/test_integration.py --replace "static_folder = '/'" "static_folder = '/x'"
    substituteInPlace tests/test_integration.py --replace "'/foo'" "'/x/foo'"
  '';

<<<<<<< HEAD
  propagatedBuildInputs = [ flask webassets flask-script nose ];
=======
  propagatedBuildInputs = [ flask webassets flask_script nose ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/miracle2k/flask-assets";
    description = "Asset management for Flask, to compress and merge CSS and Javascript files";
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
