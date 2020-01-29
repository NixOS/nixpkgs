{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm }:

buildPythonPackage rec {
  pname = "py";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e27081401262157467ad6e7f851b7aa402c5852dbcb3dae06768434de5752aa";
  };

  # Circular dependency on pytest
  doCheck = false;

  nativeBuildInputs = [ setuptools_scm ];

  pythonImportsCheck = [
    "py"
  ];

  meta = with stdenv.lib; {
    description = "Library with cross-python path, ini-parsing, io, code, log facilities";
    homepage = https://pylib.readthedocs.org/;
    license = licenses.mit;
  };
}
