{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  version = "1.0.5";
  pname = "dj-email-url";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7zb4oyTsV8875cen70TtaQDKAghiSpGKszrcHPZCezk=";
  };

  checkPhase = ''
    ${python.interpreter} test_dj_email_url.py
  '';

  # tests not included with pypi release
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/migonzalvar/dj-email-url";
    description = "Use an URL to configure email backend settings in your Django Application";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };
}
