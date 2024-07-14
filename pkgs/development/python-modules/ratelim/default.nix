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
    hash = "sha256-gm0yF34R+aEoMZAcn9pmef1bvqNgWRCCAWcIj1rLsR0=";
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
