{ lib
, buildPythonPackage
, fetchFromGitHub

# dependencies
, einops
, numpy
, torch-bin
, torchaudio-bin
}:

buildPythonPackage rec {
  pname = "encodec";
  version = "0.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "encodec";
    rev = "v${version}";
    hash = "sha256-+iJZkX1HoyuNFu9VRxMO6aAzNQybkH9lrQJ5Ao9+/CY=";
  };

  propagatedBuildInputs = [
    einops
    numpy
    torch-bin
    torchaudio-bin
  ];

  pythonImportsCheck = [ "encodec" ];

  # requires model data from the internet
  doCheck = false;

  meta = with lib; {
    description = "State-of-the-art deep learning based audio codec supporting both mono 24 kHz audio and stereo 48 kHz audio";
    homepage = "https://github.com/facebookresearch/encodec";
    changelog = "https://github.com/facebookresearch/encodec/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
