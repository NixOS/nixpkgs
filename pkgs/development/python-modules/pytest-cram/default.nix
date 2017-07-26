{lib, buildPythonPackage, fetchPypi, pytest, cram, bash, writeText}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  version = "0.1.1";
  pname = "pytest-cram";

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ cram ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ad05999iqzyjay9y5lc0cnd3jv8qxqlzsvxzp76shslmhrv0c4f";
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
