{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  version = "3.1.2";
  pname = "django-cache-url";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d0ee0d6c5daab92787bff47a4a6f5a6cf97c3c80d81a990820b2af16e12ad65a";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest tests
  '';

  # tests not included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/ghickman/django-cache-url";
    description = "Use Cache URLs in your Django application";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
