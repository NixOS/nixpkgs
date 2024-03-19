{ lib, buildPythonPackage, fetchPypi, pytest, cram, bash }:

buildPythonPackage rec {
  version = "0.2.2";
  format = "setuptools";
  pname = "pytest-cram";

  nativeCheckInputs = [ pytest ];
  propagatedBuildInputs = [ cram ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0405ymmrsv6ii2qhq35nxfjkb402sdb6d13xnk53jql3ybgmiqq0";
    extension = "tar.gz";
  };

  postPatch = ''
    substituteInPlace pytest_cram/tests/test_options.py \
      --replace "/bin/bash" "${bash}/bin/bash"
  '';

  # Remove __init__.py from tests folder, otherwise pytest raises an error that
  # the imported and collected modules are different.
  checkPhase = ''
    rm pytest_cram/tests/__init__.py
    pytest pytest_cram/ --ignore=pytest_cram/tests/test_examples.py
  '';

  meta = {
    description = "Test command-line applications with pytest and cram";
    homepage = "https://github.com/tbekolay/pytest-cram";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
