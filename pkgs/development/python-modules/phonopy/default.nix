{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pyyaml
, matplotlib
, h5py
, spglib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "phonopy";
  version = "2.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jaizhkb59ixknvc75nrhfq51bh75912q8ay36bxpf4g5hzyhw3a";
  };

  propagatedBuildInputs = [ numpy pyyaml matplotlib h5py spglib ];

  checkInputs = [ pytestCheckHook ];

  # prevent pytest from importing local directory
  preCheck = ''
    rm -r phonopy
  '';

  meta = with lib; {
    description = "A package for phonon calculations at harmonic and quasi-harmonic levels";
    homepage = "https://atztogo.github.io/phonopy/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ psyanticy ];
  };
}
