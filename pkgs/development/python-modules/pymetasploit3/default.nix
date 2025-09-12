{
  lib,
  buildPythonPackage,
  fetchPypi,
  msgpack,
  pytestCheckHook,
  requests,
  retry,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymetasploit3";
  version = "1.0.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-y4YBQo6va+/NEuE+CWeueo0aEIHEnEZYBr1WH90qHxQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msgpack
    requests
    retry
  ];

  # No tests available on PyPI
  doCheck = false;

  pythonImportsCheck = [ "pymetasploit3" ];

  meta = {
    description = "Library for Metasploit framework";
    homepage = "https://pypi.org/project/pymetasploit3/";
    license = with lib.licenses; [
      gpl2Only
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
