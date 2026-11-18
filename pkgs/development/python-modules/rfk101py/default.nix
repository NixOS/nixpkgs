{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rfk101py";
  version = "0.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O8W404opbjH4AIUAfM01xrzXM/2WzU6q7uxM5ySgdhg=";
  };

  build-system = [ setuptools ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "rfk101py" ];

  meta = {
    description = "RFK101 Proximity card reader over Ethernet";
    homepage = "https://github.com/dubnom/rfk101py";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
