{
  lib,
  buildPythonPackage,
  pykeepass,
  rpyc,
  python-daemon,
  setuptools,
  fetchPypi,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pykeepass-cache";
  version = "2.0.3";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fzb+qC8dACPr+V31DV50ElHzIePdXMX6TtepTY6fYeg=";
  };

  propagatedBuildInputs = [
    pykeepass
    rpyc
    python-daemon
  ];
  pythonImportsCheck = [ "pykeepass_cache" ];
  pyproject = true;
  build-system = [ setuptools ];

  passthru.updateScript = nix-update-script { };
  meta = {
    homepage = "https://github.com/libkeepass/pykeepass_cache";
    description = "Drop-in replacement for PyKeePass, providing access to KeePass databases with daemonized caching";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.alch-emi ];
    platforms = lib.platforms.linux;
    # Note: An official changelog is not published by the package authors
  };
}
