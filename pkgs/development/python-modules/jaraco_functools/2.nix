{ lib, buildPythonPackage, fetchPypi
, setuptools_scm
, more-itertools, backports_functools_lru_cache }:

buildPythonPackage rec {
  pname = "jaraco.functools";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ickpwvvdrlbm477gdzfjfcbgmfia9ksm9a3i3pbx9xia97r9fim";
  };

  propagatedBuildInputs = [ more-itertools backports_functools_lru_cache ];

  doCheck = false;

  buildInputs = [ setuptools_scm ];

  meta = with lib; {
    description = "Additional functools in the spirit of stdlib's functools";
    homepage = "https://github.com/jaraco/jaraco.functools";
    license = licenses.mit;
  };
}
