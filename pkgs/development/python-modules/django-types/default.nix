{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
}:

buildPythonPackage rec {
  pname = "django-types";
  version = "0.17.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wcQqt4h2xXxyg0LVqwYHJas3H8jcg7uFuuC+BoRqrXA=";
  };

  nativeBuildInputs = [ poetry-core ];

  meta = with lib; {
    description = "Type stubs for Django";
    homepage = "https://pypi.org/project/django-types";
    license = licenses.mit;
    maintainers = with maintainers; [ thubrecht ];
  };
}
