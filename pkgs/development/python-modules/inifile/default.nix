{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "inifile";
  version = "0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zgd53czc1irwx6b5zip8xlmyfr40hz2pd498d8yv61znj6lm16h";
  };

  meta = with lib; {
    description = "A small INI library for Python";
    homepage    = "https://github.com/mitsuhiko/python-inifile";
    license     = licenses.bsd0;
    maintainers = with maintainers; [ ];
  };

}
