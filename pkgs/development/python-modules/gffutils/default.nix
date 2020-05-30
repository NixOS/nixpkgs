{ python, stdenv, buildPythonPackage, fetchPypi
, pyfaidx, six, argh, argcomplete, simplejson, nose, wget }:
buildPythonPackage rec {
  version = "0.10.1";
  pname = "gffutils";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a8fc39006d7aa353147238160640e2210b168f7849cb99896be3fc9441e351cb";
  };

  checkInputs = [ nose wget ];
  propagatedBuildInputs = [ pyfaidx six argh argcomplete simplejson ];

  checkPhase = ''
    # sh gffutils/test/data/download-large-annotation-files.sh
    # nosetests
    ${python.interpreter} -c 'import gffutils'
  '';

  # Tests require extra dependencies
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/daler/gffutils";
    description = "GFF and GTF file manipulation and interconversion http://daler.github.io/gffutils";
    license = licenses.mit;
  };
}
