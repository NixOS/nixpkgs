{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "pyelftools";
  version = "0.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86ac6cee19f6c945e8dedf78c6ee74f1112bd14da5a658d8c9d4103aed5756a2";
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
