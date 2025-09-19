{ lib, python3Packages, fetchPypi, six}:

python3Packages.buildPythonPackage rec {
  pname = "imgkit";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ya3pPQKBJ3yJi5g8lZ8R8MwctKX+0URWDfpNJz+1DNg=";
  };

  propagatedBuildInputs = [ six ];
  nativeBuildInputs = [ python3Packages.setuptools-scm ];

  pythonImportsCheck = [ "imgkit" ];

  pyproject = true;

  meta = with lib; {
    homepage = "https://github.com/jarrekk/imgkit";
    description = "Wkhtmltopdf python wrapper to convert html to image using the webkit rendering engine and qt";
    license = licenses.mit;
    maintainers = with maintainers; [ twitchy0 ];
  };
}
