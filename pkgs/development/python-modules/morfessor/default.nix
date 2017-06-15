{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Morfessor";
  version = "2.0.2a4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c0qbr241vs7zamj6s3l14fgw3ssca4b58kx351jvgc1pypb70s3";
  };

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';
  
  meta = with stdenv.lib; {
    description = "Python Implementation and Extensions for Morfessor Baseline, a tool for unsupervised and semi-supervised morphological segmentation";
    homepage = https://morfessor.readthedocs.org/;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ sdll ];
    };
}
