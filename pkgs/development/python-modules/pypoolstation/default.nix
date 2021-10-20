{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pypoolstation";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyPoolstation";
    inherit version;
    sha256 = "0qacrjv3qybgx052i8jqs4il3k2g0cdhjcn2lqapv87iqyp287k0";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pypoolstation" ];

  meta = with lib; {
    description = "Python library to interact the the Poolstation platform";
    homepage = "https://github.com/cibernox/PyPoolstation";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
