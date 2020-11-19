{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  version = "1.0.1";
  pname = "dj-email-url";

  src = fetchPypi {
    inherit pname version;
    sha256 = "32dc567c5cc3d4106710ec36dd645c8c1b20e2d8f588a17ab88bcc23e347d00a";
  };

  checkPhase = ''
    ${python.interpreter} test_dj_email_url.py
  '';

  # tests not included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/migonzalvar/dj-email-url";
    description = "Use an URL to configure email backend settings in your Django Application";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };
}
