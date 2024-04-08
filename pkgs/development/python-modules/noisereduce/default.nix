{ lib
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, librosa
, tqdm
}:

buildPythonPackage rec {
  pname = "noisereduce";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a532d2223986e8295ae57a8f86fb4699a477636841237ffa8c323c959bd9c0b";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    librosa
    tqdm
  ];

  doCheck = false;

  meta = with lib; {
    description = "Noise reduction in python using spectral gating";
    homepage = "https://github.com/timsainb/noisereduce";
    license = licenses.mit;
    maintainers = with maintainers; [ moon ];
  };
}
