{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  setuptools,
  setuptools-scm,

  dask,
  hyperspy,
  matplotlib,
  numpy,
  pint,
  pooch,
  prettytable,
  requests,
  scipy,
  traits,
  h5py,
}:

buildPythonPackage rec {
  pname = "exspy";
  version = "0.3.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "hyperspy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-llU5FwSmDbpEFCF9Vw8eEcSZcF9sm8Mk2lF98Ou94cI=";
  };

  disabled = pythonOlder "3.9";

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dask
    hyperspy
    matplotlib
    numpy
    pint
    pooch
    prettytable
    requests
    scipy
    traits
    h5py
  ];

  preInstallCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "exspy" ];

  meta = with lib; {
    description = "Helping with the analysis of X-rays Energy Dispersive Spectroscopy (EDS) and Electron Energy Loss Spectroscopy (EELS) with the HyperSpy library";
    homepage = "https://hyperspy.org/exspy/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
