{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  version = "0.1.0";
  pname = "dj-email-url";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84f32673156f58d740a14cab09f04ca92a65b2c8881b60e31e09e67d7853e544";
  };

  checkPhase = ''
    ${python.interpreter} test_dj_email_url.py
  '';

  # tests not included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/migonzalvar/dj-email-url;
    description = "Use an URL to configure email backend settings in your Django Application";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };
}
