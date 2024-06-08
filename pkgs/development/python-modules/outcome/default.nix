{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  attrs,
  pytest,
}:

buildPythonPackage rec {
  pname = "outcome";
  version = "1.3.0.post0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nc8C5l8pcbgAR7N3Ro5yomjhXArzzxI45v8U9/kRQ7g=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytest ];
  propagatedBuildInputs = [ attrs ];
  # Has a test dependency on trio, which depends on outcome.
  doCheck = false;

  meta = {
    description = "Capture the outcome of Python function calls.";
    homepage = "https://github.com/python-trio/outcome";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
