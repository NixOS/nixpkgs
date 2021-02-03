{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  version = "3.2.2";
  pname = "django-cache-url";

  src = fetchPypi {
    inherit pname version;
    sha256 = "419b1667fe654a1b032073371b67d3fcfbe2a6392337c0e5e6c4ec741a6342a5";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest tests
  '';

  # tests not included with pypi release
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ghickman/django-cache-url";
    description = "Use Cache URLs in your Django application";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
