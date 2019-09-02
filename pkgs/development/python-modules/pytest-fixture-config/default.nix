{ stdenv, buildPythonPackage, fetchPypi
, setuptools-git, pytest_3 }:

buildPythonPackage rec {
  pname = "pytest-fixture-config";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "839d70343c87d6dda5bca88e3ab06e7b2027998dc1ec452c14d50be5725180a3";
  };

  nativeBuildInputs = [ setuptools-git ];

  buildInputs = [ pytest_3 ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Simple configuration objects for Py.test fixtures. Allows you to skip tests when their required config variables aren’t set.";
    homepage = https://github.com/manahl/pytest-plugins;
    license = licenses.mit;
    maintainers = with maintainers; [ ryansydnor ];
  };
}
