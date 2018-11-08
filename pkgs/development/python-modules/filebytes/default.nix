{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "filebytes";
  version = "0.9.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nkwrw3qnii346xd87gb9xdy5pjpmg7ncjxsmb08mhmy1i0libcl";
  };

  meta = with stdenv.lib; {
    homepage = "https://scoding.de/filebytes-introduction";
    license = licenses.gpl2;
    description = "Scripts to parse ELF, PE, Mach-O and OAT (Android Runtime)";
    maintainers = with maintainers; [ bennofs ];
  };

}
