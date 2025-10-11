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
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyftpdlib";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XpLnujfD5FjsRY5cIB4t65kstgEclj5qhRKmNNjYARY=";
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

  meta = with lib; {
    description = "Asynchronous FTP server library";
    homepage = "https://github.com/giampaolo/pyftpdlib/";
    changelog = "https://github.com/giampaolo/pyftpdlib/blob/release-${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "ftpbench";
  };
}
