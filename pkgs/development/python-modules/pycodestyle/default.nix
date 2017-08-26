{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.3.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rk78b66p57ala26mdldl9lafr48blv5s659sah9q50qnfjmc8k8";
  };

  meta = with lib; {
    description = "Python style guide checker (formerly called pep8)";
    homepage = https://pycodestyle.readthedocs.io;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
