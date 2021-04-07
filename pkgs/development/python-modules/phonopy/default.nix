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
  version = "2.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "389dd33f5bfe35733c8346af6cc43bbd015ccf0efa947eb04b38bd5cb9d0b89b";
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
