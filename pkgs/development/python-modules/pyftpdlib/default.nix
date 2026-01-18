{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  psutil,
  pyasyncore,
  pyasynchat,
  pyopenssl,
  pysendfile,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyftpdlib";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7w0XKoK/rhDi3sIi6HUzUUYJ1Bv0sP0PB+KdQ4D7lr8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyasyncore
    pyasynchat
    pysendfile
  ];

  optional-dependencies = {
    ssl = [ pyopenssl ];
  };

  nativeCheckInputs = [
    mock
    psutil
  ];

  # Impure filesystem-related tests cause timeouts
  # on Hydra: https://hydra.nixos.org/build/84374861
  doCheck = false;

  pythonImportsCheck = [ "pyftpdlib" ];

  meta = {
    description = "Asynchronous FTP server library";
    homepage = "https://github.com/giampaolo/pyftpdlib/";
    changelog = "https://github.com/giampaolo/pyftpdlib/blob/release-${version}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ftpbench";
  };
}
