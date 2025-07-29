{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyramid,
}:

buildPythonPackage rec {
  pname = "pyramid-exclog";
  version = "1.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "pyramid_exclog";
    inherit version;
    hash = "sha256-Tl2rYH/GifNfB9w4nG9UIqAQz0O6kujCED/4iZnPKDw=";
  };

  propagatedBuildInputs = [ pyramid ];

  pythonImportsCheck = [ "pyramid_exclog" ];

  meta = with lib; {
    description = "Package which logs to a Python logger when an exception is raised by a Pyramid application";
    homepage = "https://docs.pylonsproject.org/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ ];
  };
}
