{
  lib,
  buildPythonPackage,
  fetchPypi,
  CoreFoundation,
  CoreServices,
}:

buildPythonPackage rec {
  pname = "macfsevents";
  version = "0.8.4";

  src = fetchPypi {
    pname = "MacFSEvents";
    inherit version;
    sha256 = "sha256-v3KD8dUXdkzNyBlbIWMdu6wcUGuSC/mo6ilWsxJ2Ucs=";
  };

  buildInputs = [
    CoreFoundation
    CoreServices
  ];

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
