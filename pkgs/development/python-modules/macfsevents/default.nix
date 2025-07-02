{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "macfsevents";
  version = "0.8.4";
  format = "setuptools";

  src = fetchPypi {
    pname = "MacFSEvents";
    inherit version;
    hash = "sha256-v3KD8dUXdkzNyBlbIWMdu6wcUGuSC/mo6ilWsxJ2Ucs=";
  };

  patches = [ ./fix-packaging.patch ];

  # Some tests fail under nix build directory
  doCheck = false;

  pythonImportsCheck = [ "fsevents" ];

  meta = with lib; {
    description = "Thread-based interface to file system observation primitives";
    homepage = "https://github.com/malthe/macfsevents";
    changelog = "https://github.com/malthe/macfsevents/blob/${version}/CHANGES.rst";
    license = licenses.bsd2;
    maintainers = [ ];
    platforms = platforms.darwin;
  };
}
