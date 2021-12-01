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
, pytorch
, torchvision
, tqdm
, lib
}:

buildPythonPackage rec {
  pname   = "pywick";
  version = "0.5.6";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "achaiah";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gmlifnv9kji0d1jwg1pa8d96zg48w17qg0sgxwy1y1jf3hn37bm";
  };

  propagatedBuildInputs = [
    h5py hickle numpy pandas pillow six pytorch torchvision tqdm
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
