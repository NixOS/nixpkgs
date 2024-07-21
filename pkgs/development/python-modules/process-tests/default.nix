{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  setuptools,
}:

buildPythonPackage rec {
  pname = "process-tests";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5dV96nFhJR6RytuEvz7MhSdfsSH9R45Xn4AHd7HUJL0=";
  };

  patches = [
    (fetchpatch {
      # Add optional ignore_case param to wait_for_strings
      url = "https://github.com/ionelmc/python-process-tests/commit/236c3e83722a36eddb4abb111a2fcceb49cc9ab7.patch";
      hash = "sha256-LbLaDXHbywvsq++lklNiLw8u0USuiEpuxzpNMhXBWtE=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Tools for testing processes";
    license = licenses.bsd2;
    homepage = "https://github.com/ionelmc/python-process-tests";
  };
}
