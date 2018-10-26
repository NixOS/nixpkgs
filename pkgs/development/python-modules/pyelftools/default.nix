{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "pyelftools";
  version = "0.24";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17259kf6hwwsmizr5myp9jv3k9g5i3dvmnl8m646pfd5hpb9gpg9";
  };

  checkPhase = ''
    ${python.interpreter} test/all_tests.py
  '';

  # Tests cannot pass against system-wide readelf
  # https://github.com/eliben/pyelftools/issues/65
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A library for analyzing ELF files and DWARF debugging information";
    homepage = https://github.com/eliben/pyelftools;
    license = licenses.publicDomain;
    maintainers = [ maintainers.igsha ];
  };

}
