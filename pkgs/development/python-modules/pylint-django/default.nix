{ stdenv, buildPythonPackage, fetchPypi, pylint-plugin-utils, pylint
, django-tables2, factory_boy, pytest, python, isPy27 }:

buildPythonPackage rec {
  pname = "pylint-django";
  version = "2.0.9";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xbnmsh3d820am2blrpc5cl371il66182z80dni9gp7vpxi2amn0";
  };

  propagatedBuildInputs = [ pylint-plugin-utils pylint ];
  checkInputs = [ django-tables2 factory_boy pytest ];

  checkPhase = "${python.interpreter} pylint_django/tests/test_func.py";

  meta = with stdenv.lib; {
    description = "Pylint plugin for improving code analysis for when using Django";
    homepage = https://github.com/PyCQA/pylint-django;
    license = licenses.gpl2;
    maintainers = with maintainers; [ gerschtli ];
  };
}
