{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "filebytes";
  version = "0.9.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09e306feafd435e240b6ca22e6319ce51862dbe99e3481368fc9a2d15d2263d5";
  };

  meta = with stdenv.lib; {
    homepage = "https://scoding.de/filebytes-introduction";
    license = licenses.gpl2;
    description = "Scripts to parse ELF, PE, Mach-O and OAT (Android Runtime)";
    maintainers = with maintainers; [ bennofs ];
  };

}
