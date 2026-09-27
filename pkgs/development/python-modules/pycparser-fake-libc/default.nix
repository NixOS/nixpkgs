{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycparser-fake-libc";
  version = "2.21";
  pyproject = true;

  # Fetching from GitHub causes headers to not be included
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pG+12tpUgYLDnaNAps1zZoUTWf+3je4nzGGdZcM6Ueg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pycparser_fake_libc" ];

  # No tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/ThomasGerstenberg/pycparser-fake-libc/releases/tag/v${version}";
    description = "Pip-installable package which contains the fake libc headers from pycparser ";
    homepage = "https://github.com/ThomasGerstenberg/pycparser-fake-libc";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.gigahawk ];
  };
}
