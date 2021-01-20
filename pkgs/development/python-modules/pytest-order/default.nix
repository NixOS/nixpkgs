{ buildPythonPackage
, fetchPypi
, lib
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-order";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qd9zfpcbzm43knkg3ap22wssqabc2wn5ynlgg661xg6r6g6iy4k";
  };

  propagatedBuildInputs = [ pytest ];

  meta = {
    description = "Pytest plugin that allows you to customize the order in which your tests are run";
    homepage = "https://github.com/mrbean-bremen/pytest-order";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jacg ];
  };
}
