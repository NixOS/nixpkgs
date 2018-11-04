{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "filebytes";
  version = "0.9.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a3e6b1aee89599437da3936170d38b5a49280c8ce774764e0e506cd9ee2a0f8";
  };

  meta = with stdenv.lib; {
    homepage = "https://scoding.de/filebytes-introduction";
    license = licenses.gpl2;
    description = "Scripts to parse ELF, PE, Mach-O and OAT (Android Runtime)";
    maintainers = with maintainers; [ bennofs ];
  };

}
