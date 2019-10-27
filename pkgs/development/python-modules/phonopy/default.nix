{ stdenv, buildPythonPackage, python, fetchPypi, numpy, pyyaml, matplotlib, h5py }:

buildPythonPackage rec {
  pname = "phonopy";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "46baf7c4571fe75374071674727c2beb0388cf57073e0623d8457f04b1c54495";
  };

  propagatedBuildInputs = [ numpy pyyaml matplotlib h5py ];

  checkPhase = ''
    cd test
    # dynamic structure factor test ocassionally fails do to roundoff
    # see issue https://github.com/atztogo/phonopy/issues/79
    rm spectrum/test_dynamic_structure_factor.py
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
