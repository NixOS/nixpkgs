{ buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytest
, h5py
, hickle
, numpy
, pandas
, pillow
, six
, torch
, torchvision
, tqdm
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

  propagatedBuildInputs = [
    h5py hickle numpy pandas pillow six torch torchvision tqdm
  ];

  checkInputs = [ pytest ];

  checkPhase = ''
    runHook preCheck
    pytest tests/
    runHook postCheck
  '';

  meta = {
    description = "High-level training framework for Pytorch";
    homepage = "https://github.com/achaiah/pywick";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
