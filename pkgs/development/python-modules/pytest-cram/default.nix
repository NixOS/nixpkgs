{lib, buildPythonPackage, fetchPypi, pytest, cram, bash}:

buildPythonPackage rec {
  version = "0.2.0";
  pname = "pytest-cram";

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ cram ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "006p5dr3q794sbwwmxmdls3nwq0fvnyrxxmc03pgq8n74chl71qn";
    extension = "zip";
  };

  postPatch = ''
    substituteInPlace pytest_cram/tests/test_options.py \
      --replace "/bin/bash" "${bash}/bin/bash"
  '';

  # Remove __init__.py from tests folder, otherwise pytest raises an error that
  # the imported and collected modules are different.
  checkPhase = ''
    rm pytest_cram/tests/__init__.py
    pytest pytest_cram
  '';

  meta = {
    description = "Test command-line applications with pytest and cram";
    homepage = https://github.com/tbekolay/pytest-cram;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
