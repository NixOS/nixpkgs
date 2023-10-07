{ lib
, buildPythonPackage
, fetchFromGitHub
, cycler
, future
, h5py
, kiwisolver
, matplotlib
, numpy
, pandas
, pyparsing
, python-dateutil
, pytz
, scikit-learn
, scipy
, seaborn
, six
, torch
, torchvision
, tqdm
, unittestCheckHook
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "cpflows";
  version = "0.1.0";
  format = "setuptools";

  disable = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "lostella";
    repo = "CP-Flow";
    rev = "96307119fe734c3226b0f685ddaf10f0004fb177"; # gluonts-dependency branch head
    hash = "sha256-VtDDjpOv85GbBqv0wyyw4A4XOV+8aoLz8XGM0IB2Fec=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "cycler"
    "future"
    "kiwisolver"
    "pyparsing"
    "pytz"
    "seaborn"
    "six"
  ];

  pythonRemoveDeps = [
    "backports.functools-lru-cache"
    "subprocess32"
  ];

  propagatedBuildInputs = [
    cycler
    future
    h5py
    kiwisolver
    matplotlib
    numpy
    pandas
    pyparsing
    python-dateutil
    pytz
    scikit-learn
    scipy
    seaborn
    torch
    torchvision
    tqdm
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "cpflows" ];

  meta = with lib; {
    description = "Convex potential flows";
    homepage = "https://github.com/lostella/CP-Flow";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
