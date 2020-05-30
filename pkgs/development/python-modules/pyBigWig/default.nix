{ stdenv, buildPythonPackage, fetchPypi, numpy, pytest, zlib }:
buildPythonPackage rec {
  version = "0.3.17";
  pname = "pyBigWig";

  src = fetchPypi {
    inherit pname version;
    sha256 = "41f64f802689ed72e15296a21a4b7abd3904780b2e4f8146fd29098fc836fd94";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy zlib ];

  checkPhase = ''
    pytest
  '';

  # Tests require extra dependencies
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/deeptools/pyBigWig";
    description = "A python extension for quick access to bigWig and bigBed files";
    license = licenses.mit;
  };
}
