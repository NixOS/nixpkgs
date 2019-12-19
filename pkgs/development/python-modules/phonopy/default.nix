{ stdenv, buildPythonPackage, python, fetchPypi, numpy, pyyaml, matplotlib, h5py }:

buildPythonPackage rec {
  pname = "phonopy";
  version = "2.4.1.post5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a393ed79a600fe6371677890198a2d05ad27c37935aa83977f5244dfe3eac96";
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
