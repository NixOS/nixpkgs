{ lib, buildPythonPackage, fetchPypi, CoreFoundation, CoreServices }:

buildPythonPackage rec {
  pname = "MacFSEvents";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-v3KD8dUXdkzNyBlbIWMdu6wcUGuSC/mo6ilWsxJ2Ucs=";
  };

  buildInputs = [ CoreFoundation CoreServices ];

  # Some tests fail under nix build directory
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/malthe/macfsevents";
    description = "Thread-based interface to file system observation primitives";
    license = licenses.bsd2;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.darwin;
  };
}
