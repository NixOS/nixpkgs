{
  lib,
  buildPythonPackage,
  fetchPypi,
  flask,
}:

buildPythonPackage rec {
  pname = "flask-swagger-ui";
  version = "5.21.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "flask_swagger_ui";
    inherit version;
    hash = "sha256-hy0DjcEaaOrKuI9vBb48UzqjAEU+Jzd12tPgKbMeA9Q=";
  };

  doCheck = false; # there are no tests

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    homepage = "https://github.com/sveint/flask-swagger-ui";
    license = licenses.mit;
    description = "Swagger UI blueprint for Flask";
    maintainers = with maintainers; [ vanschelven ];
  };
}
