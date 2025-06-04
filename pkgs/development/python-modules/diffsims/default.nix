{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  diffpy-structure,
  matplotlib,
  numba,
  numpy,
  orix,
  psutil,
  scipy,
  tqdm,
  transforms3d,
}:

buildPythonPackage rec {
  pname = "diffsims";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "pyxem";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xrhqLVipZbRxk1g/XIvDIb0e/M0RlOYMBBTOh374XVk=";
  };

  disabled = pythonOlder "3.6";

  dependencies = [
    diffpy-structure
    matplotlib
    numba
    numpy
    orix
    psutil
    scipy
    tqdm
    (transforms3d.overrideAttrs (oldAttrs: {
      doCheck = false;
      doInstallCheck = false;
    })) # Issue with transforms3d package tests, will evaluate if this override is still needed with updates
  ];

  pythonImportsCheck = [ "diffsims" ];

  meta = with lib; {
    description = "An open-source Python library providing utilities for simulating diffraction";
    homepage = "https://github.com/pyxem/diffsims";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
