{ stdenv, buildPythonPackage, python, fetchPypi, numpy, pyyaml, matplotlib, h5py }:

buildPythonPackage rec {
  pname = "phonopy";
  version = "2.3.2.post11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4b4ef1c11bafa161a409ad018cbf8469aacd42fc77fd954442760161f63dd345";
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
