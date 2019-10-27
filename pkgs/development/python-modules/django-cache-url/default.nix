{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  version = "3.0.0";
  pname = "django-cache-url";

  src = fetchPypi {
    inherit pname version;
    sha256 = "235950e2d7cb16164082167c2974301e2f0fb2313d40bfacc9d24f5b09c3514b";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest tests
  '';

  # tests not included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/ghickman/django-cache-url;
    description = "Use Cache URLs in your Django application";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
