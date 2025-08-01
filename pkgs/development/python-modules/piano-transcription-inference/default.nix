{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  fetchurl,
  librosa,
  matplotlib,
  mido,
  setuptools,
  torch,
  torchlibrosa,
}:

buildPythonPackage rec {
  pname = "piano-transcription-inference";
  version = "0.0.6";
  pyproject = true;

  src = fetchPypi {
    pname = "piano_transcription_inference";
    inherit version;
    hash = "sha256-tt0A+bS8rLYUByXwO0E5peD0rNNaaeSSpdH3NOz70jE=";
  };

  checkpoint = fetchurl {
    name = "piano-transcription-inference.pth";
    # The download url can be found in
    # https://github.com/qiuqiangkong/piano_transcription_inference/blob/master/piano_transcription_inference/inference.py
    url = "https://zenodo.org/record/4034264/files/CRNN_note_F1%3D0.9677_pedal_F1%3D0.9186.pth?download=1";
    hash = "sha256-w/qXMHJb9Kdi8cFLyAzVmG6s2gGwJvWkolJc1geHYUE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    librosa
    matplotlib
    mido
    torch
    torchlibrosa
  ];

  patches = [
    # Fix run against librosa 0.10.0
    # https://github.com/qiuqiangkong/piano_transcription_inference/pull/14
    (fetchpatch {
      url = "https://github.com/qiuqiangkong/piano_transcription_inference/commit/b2d448916be771cd228f709c23c474942008e3e8.patch";
      hash = "sha256-8O4VtFij//k3fhcbMRz4J8Iz4AdOPLkuk3UTxuCSy8U=";
    })
    (fetchpatch {
      url = "https://github.com/qiuqiangkong/piano_transcription_inference/commit/61443632dc5ea69a072612b6fa3f7da62c96b72c.patch";
      hash = "sha256-I9+Civ95BnPUX0WQhTU/pGQruF5ctIgkIdxCK+xO3PE=";
    })
  ];

  postPatch = ''
    substituteInPlace piano_transcription_inference/inference.py --replace \
      "checkpoint_path='{}/piano_transcription_inference_data/note_F1=0.9677_pedal_F1=0.9186.pth'.format(str(Path.home()))" \
      "checkpoint_path='$out/share/checkpoint.pth'"
  '';

  postInstall = ''
    mkdir "$out/share"
    ln -s "${checkpoint}" "$out/share/checkpoint.pth"
  '';

  # Project has no tests.
  # In order to make pythonImportsCheck work, NUMBA_CACHE_DIR env var need to
  # be set to a writable dir (https://github.com/numba/numba/issues/4032#issuecomment-488102702).
  # pythonImportsCheck has no pre* hook, use checkPhase to workaround that.
  checkPhase = ''
    export NUMBA_CACHE_DIR="$(mktemp -d)"
  '';
  pythonImportsCheck = [ "piano_transcription_inference" ];

  meta = with lib; {
    description = "Piano transcription inference package";
    homepage = "https://github.com/qiuqiangkong/piano_transcription_inference";
    license = licenses.mit;
    maintainers = with maintainers; [ azuwis ];
  };
}
