{ stdenv, buildPythonPackage, fetchPypi
, numpy, pandas, datacache, six, memoized-property, gtfparse, serializable, tinytimer, setuptools }:

buildPythonPackage rec {
  version = "1.8.5";
  pname = "pyensembl";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13dd05aba296e4acadb14de5a974e6f73834452851a36b9237917ae85b3e060f";
  };

  checkInputs = [ ];
  propagatedBuildInputs = [ numpy pandas datacache six memoized-property gtfparse serializable tinytimer serializable ];

  checkPhase = ''
  '';

  # Tests require extra dependencies
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/openvax/pyensembl";
    description = " Python interface to access reference genome features (such as genes, transcripts, and exons) from Ensembl ";
    license = licenses.asl20;
  };
}
