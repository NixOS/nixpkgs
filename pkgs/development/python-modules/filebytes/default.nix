{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "filebytes";
  version = "0.9.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mb349fx38n9iwv82d4yx7dn4675khqyc8nanr0f4dflmzz0dqq9";
  };

  meta = with stdenv.lib; {
    homepage = "https://scoding.de/filebytes-introduction";
    license = licenses.gpl2;
    description = "Scripts to parse ELF, PE, Mach-O and OAT (Android Runtime)";
    maintainers = with maintainers; [ bennofs ];
  };

}
