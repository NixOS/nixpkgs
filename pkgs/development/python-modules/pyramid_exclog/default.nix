{ lib
, buildPythonPackage
, fetchPypi
, pyramid
}:

buildPythonPackage rec {
  pname = "pyramid_exclog";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d05ced5c12407507154de6750036bc83861b85c11be70b3ec3098c929652c14b";
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
