{ lib
, buildPythonPackage
, fetchPypi
, pyramid
}:

buildPythonPackage rec {
  pname = "pyramid_exclog";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Tl2rYH/GifNfB9w4nG9UIqAQz0O6kujCED/4iZnPKDw=";
  };

  propagatedBuildInputs = [ pyramid ];

  pythonImportsCheck = [ "pyramid_exclog" ];

  meta = with lib; {
    description = "A package which logs to a Python logger when an exception is raised by a Pyramid application";
    homepage = "https://docs.pylonsproject.org/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };

}
