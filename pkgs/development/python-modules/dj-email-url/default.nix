{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  version = "0.2.0";
  pname = "dj-email-url";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0362e390c17cc377f03bcbf6daf3f671797c929c1bf78a9f439d78f215ebe3fd";
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
