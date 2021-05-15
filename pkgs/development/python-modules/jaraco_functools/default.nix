{ lib, buildPythonPackage, fetchPypi
, setuptools_scm, toml
, more-itertools, backports_functools_lru_cache }:

buildPythonPackage rec {
  pname = "jaraco.functools";
  version = "3.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97cf88b46ab544c266e2d81fa17bb183622268722a7dd1a3711ea426e9c26f94";
  };

  nativeBuildInputs = [ setuptools_scm toml ];

  propagatedBuildInputs = [ more-itertools backports_functools_lru_cache ];

  doCheck = false;

  pythonNamespaces = [ "jaraco" ];

  meta = with lib; {
    description = "Additional functools in the spirit of stdlib's functools";
    homepage = "https://github.com/jaraco/jaraco.functools";
    license = licenses.mit;
  };
}
