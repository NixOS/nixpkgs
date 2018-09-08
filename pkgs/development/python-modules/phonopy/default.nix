{ stdenv, buildPythonPackage, python, fetchPypi, numpy, pyyaml, matplotlib, h5py }:

buildPythonPackage rec {
  pname = "phonopy";
  version = "1.13.2.107";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72f06728c98b9a7ab3db2d6fa2ae5d029029fbcff4e8fcfbc29f1e2620a0f905";
  };

  propagatedBuildInputs = [ numpy pyyaml matplotlib h5py ];
  
  checkPhase = ''
    cd test/phonopy
    ${python.interpreter} -m unittest discover -b
    cd ../..
  '';

  meta = with stdenv.lib; {
    description = "A package for phonon calculations at harmonic and quasi-harmonic levels";
    homepage = https://atztogo.github.io/phonopy/;
    license = licenses.bsd0;
    maintainers = with maintainers; [ psyanticy ];
  };
}

