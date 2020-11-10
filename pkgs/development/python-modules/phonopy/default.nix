{ stdenv, buildPythonPackage, python, fetchPypi, numpy, pyyaml, matplotlib, h5py, spglib, pytestCheckHook }:

buildPythonPackage rec {
  pname = "phonopy";
  version = "2.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "28864b04adb900597705f1367a100da869af835088bdd13f1693c4382259f128";
  };

  propagatedBuildInputs = [ numpy pyyaml matplotlib h5py spglib ];

  checkInputs = [ pytestCheckHook ];
  # flakey due to floating point inaccuracy
  disabledTests = [ "test_NaCl" ];

  # prevent pytest from importing local directory
  preCheck = ''
    rm -r phonopy
  '';

  meta = with stdenv.lib; {
    description = "A package for phonon calculations at harmonic and quasi-harmonic levels";
    homepage = "https://atztogo.github.io/phonopy/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ psyanticy ];
  };
}
