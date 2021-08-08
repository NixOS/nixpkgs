{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pyyaml
, matplotlib
, h5py
, scipy
, spglib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "phonopy";
  version = "2.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "58485042ab7d88fc8b83744d18b2aefd677adb071c8a717ac3710458192743d7";
  };

  propagatedBuildInputs = [
    h5py
    matplotlib
    numpy
    pyyaml
    scipy
    spglib
  ];

  checkInputs = [
    pytestCheckHook
  ];

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
