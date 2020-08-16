{ stdenv, buildPythonPackage, python, fetchPypi, numpy, pyyaml, matplotlib, h5py }:

buildPythonPackage rec {
  pname = "phonopy";
  version = "2.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "482c6ff29c058d091ac885e561e28ba3e516ea9e91c44a951cad11f3ae19856c";
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
    homepage = "https://atztogo.github.io/phonopy/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ psyanticy ];
  };
}
