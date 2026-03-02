{
  buildPythonPackage,
  config,
  fetchPypi,
  ffmpeg,
  gdown,
  keras,
  kerasWithCuda,
  lib,
  matplotlib,
  numpy,
  opencv-python,
  opencv-python-withCuda,
  pillow,
  scikit-image,
  setuptools,
  tensorflow,
  tensorflowWithCuda,
  tqdm,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "opennsfw2";
  version = "0.10.2";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-xs6gcy3A8Y52YWXAg0JXechMpqAfEWm/pdDUqgUxHk8=";
  };

  doCheck = false;
  pyproject = true;

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    ffmpeg
    gdown
    matplotlib
    numpy
    pillow
    scikit-image
    tqdm
  ]
  ++ lib.lists.optionals (!config.cudaSupport) [
    keras
    opencv-python
    tensorflow
  ]
  ++ lib.lists.optionals config.cudaSupport [
    kerasWithCuda
    opencv-python-withCuda
    tensorflowWithCuda
  ];

  meta = {
    changelog = "https://github.com/bhky/opennsfw2/releases/tag/v${finalAttrs.version}";
    description = "Keras implementation of the Yahoo Open-NSFW model";
    homepage = "https://github.com/bhky/opennsfw2/tree/v${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      S0AndS0
    ];
  };
})
