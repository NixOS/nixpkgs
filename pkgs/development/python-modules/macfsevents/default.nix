{ lib, buildPythonPackage, fetchPypi, CoreFoundation, CoreServices }:

buildPythonPackage rec {
  pname = "MacFSEvents";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1324b66b356051de662ba87d84f73ada062acd42b047ed1246e60a449f833e10";
  };

  buildInputs = [ CoreFoundation CoreServices ];

  # Some tests fail under nix build directory
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/malthe/macfsevents;
    description = "Thread-based interface to file system observation primitives";
    license = licenses.bsd2;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.darwin;
  };
}
