{ lib, fetchPypi, buildPythonPackage
, flake8-polyfill }:

buildPythonPackage rec {
  pname = "pep8-naming";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1brwm5yn1niydb58w2jz0ajnp1chp1qbmmpcglb1lcjnf0bkhgd3";
  };

  propagatedBuildInputs = [
    flake8-polyfill
  ];

  meta = with lib; {
    homepage = https://github.com/PyCQA/pep8-naming;
    description = "Check PEP-8 naming conventions, plugin for flake8";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
