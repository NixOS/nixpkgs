{
  lib,
  buildPythonPackage,
  fetchPypi,
  enum34,
}:

buildPythonPackage rec {
  pname = "enum-compat";
  version = "0.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Nnfaq+1WpvckRR1YVmIlPY+05VaYRar6i7DaNrGodR4=";
  };

  propagatedBuildInputs = [ enum34 ];

  meta = with lib; {
    homepage = "https://github.com/jstasiak/enum-compat";
    description = "enum/enum34 compatibility package";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
