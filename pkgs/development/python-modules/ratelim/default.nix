{
  lib,
  buildPythonPackage,
  fetchPypi,
  decorator,
}:

buildPythonPackage rec {
  pname = "ratelim";
  version = "0.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07dirdd8y23706110nb0lfz5pzbrcvd9y74h64la3y8igqbk4vc2";
  };

  propagatedBuildInputs = [ decorator ];

  pythonImportsCheck = [ "ratelim" ];

  # package has no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/themiurgo/ratelim";
    description = "Simple Python library that limits the number of times a function can be called during a time interval";
    license = licenses.mit;
    maintainers = with maintainers; [ dgliwka ];
  };
}
