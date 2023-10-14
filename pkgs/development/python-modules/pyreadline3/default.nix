{ buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pyreadline3";
  version = "3.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bkv3zrfzmhbsd38dslsydi0arnc50gzrkhp76vk5fiii9xiygbg";
  };

  # TODO FIXME
  doCheck = false;

  meta = { };
}
