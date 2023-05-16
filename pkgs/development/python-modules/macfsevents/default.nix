<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, CoreFoundation
, CoreServices
}:

buildPythonPackage rec {
  pname = "MacFSEvents";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-v3KD8dUXdkzNyBlbIWMdu6wcUGuSC/mo6ilWsxJ2Ucs=";
=======
{ lib, buildPythonPackage, fetchPypi, CoreFoundation, CoreServices }:

buildPythonPackage rec {
  pname = "MacFSEvents";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1324b66b356051de662ba87d84f73ada062acd42b047ed1246e60a449f833e10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ CoreFoundation CoreServices ];

  # Some tests fail under nix build directory
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [ "fsevents" ];

  meta = with lib; {
    description = "Thread-based interface to file system observation primitives";
    homepage = "https://github.com/malthe/macfsevents";
    changelog = "https://github.com/malthe/macfsevents/blob/${version}/CHANGES.rst";
=======
  meta = with lib; {
    homepage = "https://github.com/malthe/macfsevents";
    description = "Thread-based interface to file system observation primitives";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd2;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.darwin;
  };
}
