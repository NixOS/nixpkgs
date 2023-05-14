{ buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, dill
, h5py
, hickle
, numpy
, opencv4
, pandas
, pillow
, pycm
, pyyaml
, scipy
, requests
, scikitimage
, six
, tabulate
, torch
, torchvision
, tqdm
, yacs
, lib
}:

buildPythonPackage rec {
  pname   = "pywick";
  version = "0.6.5";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "achaiah";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wnijdvqgdpzfdsy1cga3bsr0n7zzsl8hp4dskqwxx087g5h1r84";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "opencv-python-headless" "opencv"
  '';

  propagatedBuildInputs = [
    dill
    h5py
    hickle
    numpy
    opencv4
    pandas
    pillow
    pycm
    pyyaml
    scipy
    requests
    scikitimage
    tabulate
    torch
    torchvision
    tqdm
    six
    yacs
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "High-level training framework for Pytorch";
    homepage = "https://github.com/achaiah/pywick";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
    broken = true;  # Nixpkgs missing `albumentations` and `prodict`
  };
}
