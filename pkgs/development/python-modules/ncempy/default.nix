{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  numpy,
  scipy,
  matplotlib,
  h5py,
}:

buildPythonPackage rec {
  pname = "ncempy";
  version = "1.12";

  src = fetchFromGitHub {
    owner = "ercius";
    repo = "openNCEM";
    rev = "v${version}";
    hash = "sha256-f5jI864sirV0o5R9TuMZkSOJE04U10iSUJAvb6b5OHg=";
  };

  dependencies = [
    numpy
    scipy
    matplotlib
    h5py
  ];

  pythonImportsCheck = [ "ncempy" ];

  meta = with lib; {
    description = "A collection of packages and tools for electron microscopy data analysis supported by the National Center for Electron Microscopy facility of the Molecular Foundry";
    homepage = "https://openncem.readthedocs.io/en/latest/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
