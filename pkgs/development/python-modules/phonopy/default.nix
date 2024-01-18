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
, pythonOlder
}:

buildPythonPackage rec {
  pname = "phonopy";
  version = "2.21.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WAWxgLwChQrwutpRsJtDUoNnwek6RpZB+9JtUFdr/pw=";
  };

  propagatedBuildInputs = [
    h5py
    matplotlib
    numpy
    pyyaml
    scipy
    spglib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # prevent pytest from importing local directory
  preCheck = ''
    rm -r phonopy
  '';

  pythonImportsCheck = [
    "phonopy"
  ];

  meta = with lib; {
    description = "Modulefor phonon calculations at harmonic and quasi-harmonic levels";
    homepage = "https://phonopy.github.io/phonopy/";
    changelog = "https://github.com/phonopy/phonopy/blob/v${version}/doc/changelog.md";
    license = licenses.bsd0;
    maintainers = with maintainers; [ psyanticy ];
  };
}
