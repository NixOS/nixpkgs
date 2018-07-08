{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fhy4vnlgpjq4qd1wdnl6pvdw7rah0ypmn8c9mkhz8clsndskz6b";
  };

  meta = with lib; {
    description = "Python style guide checker (formerly called pep8)";
    homepage = https://pycodestyle.readthedocs.io;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
