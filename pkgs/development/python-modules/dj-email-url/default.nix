{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
}:

buildPythonPackage rec {
  pname = "dj-email-url";
  version = "1.0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Vf/jMp5I9U+Kdao27OCPNl4J1h+KIJdz7wmh1HYOaZo=";
  };

  checkPhase = ''
    ${python.interpreter} test_dj_email_url.py
  '';

  # tests not included with pypi release
  doCheck = false;

  meta = {
    description = "Use an URL to configure email backend settings in your Django Application";
    homepage = "https://github.com/migonzalvar/dj-email-url";
    license = lib.licenses.bsd0;
    maintainers = [ ];
  };
}
