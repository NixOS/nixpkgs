{ lib, buildPythonPackage, fetchPypi
, setuptools_scm, toml
, more-itertools, backports_functools_lru_cache }:

buildPythonPackage rec {
  pname = "jaraco.functools";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fedc4be3117512ca3e03e1b2ffa7a6a6ffa589bfb7d02bfb324e55d493b94f4";
  };

  nativeBuildInputs = [ setuptools_scm toml ];

  propagatedBuildInputs = [ more-itertools backports_functools_lru_cache ];

  doCheck = false;

  meta = with lib; {
    description = "Additional functools in the spirit of stdlib's functools";
    homepage = "https://github.com/jaraco/jaraco.functools";
    license = licenses.mit;
  };
}
