{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  version = "1.0.4";
  pname = "dj-email-url";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ee35df51065d17ac7b55e98ad8eda3a1f6c5d65fc89cdc5de7a96e534942553";
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
