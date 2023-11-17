{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, cython_3
, setuptools

# dependencies
, filterpy
, numba
, numpy
, opencv4
, pillow
, scipy
, torch
, torchvision
, tqdm
}:

buildPythonPackage rec {
  pname = "facexlib";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xinntao";
    repo = "facexlib";
    rev = "v${version}";
    hash = "sha256-2mqjGtrOigOxyGFEFZBK2/SqEhIv5cbrQU/bYDVje7Q=";
  };

  nativeBuildInputs = [
    cython_3
    setuptools
  ];

  propagatedBuildInputs = [
    filterpy
    numba
    numpy
    opencv4
    pillow
    scipy
    torch
    torchvision
    tqdm
  ];

  pythonImportsCheck = [
    "facexlib"
  ];

  meta = with lib; {
    changelog = "https://github.com/xinntao/facexlib/releases/tag/v${version}";
    description = "FaceXlib aims at providing ready-to-use face-related functions based on current STOA open-source methods";
    homepage = "https://github.com/xinntao/facexlib";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
