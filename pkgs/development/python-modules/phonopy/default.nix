{ stdenv, buildPythonPackage, python, fetchPypi, numpy, pyyaml, matplotlib, h5py }:

buildPythonPackage rec {
  pname = "phonopy";
  version = "1.13.2.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "23970ecdf698e743f9204711e8edfbb33c97667f5f88c7bda3322abbc91d0682";
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

