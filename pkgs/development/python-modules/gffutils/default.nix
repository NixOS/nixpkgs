{ stdenv, buildPythonPackage, fetchPypi
, pyfaidx, six, argh, argcomplete, simplejson }:
buildPythonPackage rec {
  version = "0.10.1";
  pname = "gffutils";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a8fc39006d7aa353147238160640e2210b168f7849cb99896be3fc9441e351cb";
  };

  checkInputs = [ ];
  propagatedBuildInputs = [ pyfaidx six argh argcomplete simplejson ];

  checkPhase = ''
  '';

  # Tests require extra dependencies
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/daler/gffutils";
    description = "GFF and GTF file manipulation and interconversion http://daler.github.io/gffutils";
    license = licenses.mit;
  };
}
