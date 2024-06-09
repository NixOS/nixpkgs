{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "py";
  version = "1.11.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "51c75c4126074b472f746a24399ad32f6053d1b34b68d2fa41e558e6f4a98719";
  };

  # Circular dependency on pytest
  doCheck = false;

  nativeBuildInputs = [ setuptools-scm ];

  pythonImportsCheck = [ "py" ];

  meta = with lib; {
    description = "Library with cross-python path, ini-parsing, io, code, log facilities";
    homepage = "https://py.readthedocs.io/";
    license = licenses.mit;
  };
}
