{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestrunner
, numpy
, matplotlib
, pytorch
, tqdm
, soundfile
, librosa
, yq
, h5py
, tensorboardx
, flake8
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "parallel-wavegan";
  version = "unstable-2020-03-22";

  src = fetchFromGitHub {
    owner = "erogol";
    repo = "ParallelWaveGAN";
    rev = "46a6fb884132887b2de8724253415293dfac7fa8";
    sha256 = "18paa27iz6gxp53jn3ii6wwcawqvhgbd1vawz20z927sicc5z5yg";
  };

  propagatedBuildInputs = [
    numpy
    matplotlib
    pytorch
    tqdm
    soundfile
    librosa
    yq
    h5py
    tensorboardx
  ];

  postPatch = ''
    # License of kaldiio is unclear, looks propritary
    # Since its only used for training, skip it for now.
    sed -i -e '/kaldiio/d' setup.py
  '';

  # requires not packaged dependencies
  doCheck = false;

  pythonImportsCheck = [
    "parallel_wavegan.models"
    "parallel_wavegan.optimizers"
    # FIXME: needs kaldiio
    #"parallel_wavegan.datasets"
    "parallel_wavegan.layers"
  ];

  buildInputs = [
    pytestrunner
  ];

  meta = with lib; {
    homepage = "https://github.com/erogol/ParallelWaveGAN";
    description = "ParallelWaveGAN adaptation for Mozilla TTS";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa mic92 ];
  };
}
