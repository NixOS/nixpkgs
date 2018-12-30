{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "pyelftools";
  version = "0.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "89c6da6f56280c37a5ff33468591ba9a124e17d71fe42de971818cbff46c1b24";
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
