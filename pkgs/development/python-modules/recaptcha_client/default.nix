{ stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "recaptcha-client";
  version = "1.0.6";
  disabled = pythonAtLeast "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "28c6853c1d13d365b7dc71a6b05e5ffb56471f70a850de318af50d3d7c0dea2f";
  };

  meta = with stdenv.lib; {
    description = "A CAPTCHA for Python using the reCAPTCHA service";
    homepage = http://recaptcha.net/;
    license = licenses.mit;
  };

}
