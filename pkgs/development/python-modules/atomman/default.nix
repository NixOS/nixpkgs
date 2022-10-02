{ lib
, ase
, buildPythonPackage
, cython
, datamodeldict
, fetchFromGitHub
, fetchpatch
, matplotlib
, numericalunits
, numpy
, pandas
, phonopy
, potentials
, pymatgen
, pytest
, pytestCheckHook
, pythonOlder
, pythonAtLeast
, requests
, scipy
, toolz
, xmltodict
}:

buildPythonPackage rec {
  version = "1.4.5";
  pname = "atomman";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "atomman";
    rev = "v${version}";
    hash = "sha256-wXz/uHjXKHVKJu/HoFF2mADSBLp6UGF9ivOp2ZOz/Ys=";
  };

  patches = [
    # Fix several tests that are failing on master.
    # https://github.com/usnistgov/atomman/pull/9
    (fetchpatch {
      name = "fix-tests-1.patch";
      url = "https://github.com/usnistgov/atomman/commit/d255977a5e0ce4584e2c886f6c55ccb9f5932731.patch";
      hash = "sha256-lBFOgcozY85JfQVsVjd51Jf9mrokwQuYdxa8l7VzkqU=";
    })
    (fetchpatch {
      name = "fix-tests-2.patch";
      url = "https://github.com/usnistgov/atomman/commit/de4177f28ad7c48d482cb606f323128e2fcb86aa.patch";
      hash = "sha256-+YpwdKCT/OTue3b2GOk9Jagg26r1PTTV2Zg+GGBd8sM=";
    })
    (fetchpatch {
      name = "fix-tests-3.patch";
      url = "https://github.com/usnistgov/atomman/commit/10b168493ee883348699f1e42680423cec84bed5.patch";
      hash = "sha256-b4f3POjiceq3xApfjnKAs9dEf1trCiTIyu7hMPL0ZTw=";
    })
    (fetchpatch {
      name = "fix-tests-4.patch";
      url = "https://github.com/usnistgov/atomman/commit/057d24c70427bab3c7c530251ceb5f4e27eb5c56.patch";
      hash = "sha256-FTg/GNRZ5xigGW8SpUTIw2/GEzOxwb1rsv2wGebmZOk=";
    })
  ];

  propagatedBuildInputs = [
    cython
    datamodeldict
    matplotlib
    numericalunits
    numpy
    pandas
    potentials
    requests
    scipy
    toolz
    xmltodict
  ];

  preCheck = ''
    # By default, pytestCheckHook imports atomman from the current directory
    # instead of from where `pip` installs it and fails due to missing Cython
    # modules. Fix this by removing atomman from the current directory.
    #
    rm -r atomman
  '';

  checkInputs = [
    ase
    phonopy
    pymatgen
    pytest
    pytestCheckHook
  ];

  disabledTests = [
    "test_unique_shifts_prototype" # needs network access to download database files
  ];

  pythonImportsCheck = [
    "atomman"
  ];

  meta = with lib; {
    description = "Atomistic Manipulation Toolkit";
    homepage = "https://github.com/usnistgov/atomman/";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
