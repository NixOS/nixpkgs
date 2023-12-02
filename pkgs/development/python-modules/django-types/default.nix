{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
}:

buildPythonPackage rec {
  pname = "django-types";
  version = "0.19.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WueYhhLPb7w1ewGLvDs6h4tl4EJ1zEbg011mpwja/xI=";
  };

  nativeBuildInputs = [ poetry-core ];

  meta = with lib; {
    description = "Type stubs for Django";
    homepage = "https://pypi.org/project/django-types";
    license = licenses.mit;
    maintainers = with maintainers; [ thubrecht ];
  };
}
