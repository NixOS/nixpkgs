{
  buildPythonPackage,
  comtypes,
  config,
  fetchPypi,
  lib,
  numpy,
  opencv-python,
  opencv-python-withCuda,
  setuptools,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygrabber";
  version = "0.2";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-5YSxGdTJuajzOes00f5/3RYhSiv1oYdhcRRcrr255BM=";
  };

  doCheck = false;
  pyproject = true;

  build-system = [
    wheel
    setuptools
  ];

  ## WARN: pygrabber==0.1 is in requirements.txt wat?!
  dependencies = [
    comtypes
    numpy
  ]
  ++ lib.lists.optionals (!config.cudaSupport) [
    opencv-python
  ]
  ++ lib.lists.optionals config.cudaSupport [
    opencv-python-withCuda
  ];

  meta = {
    changelog = "https://pypi.org/project/pygrabber/${finalAttrs.version}";
    description = "Python library that enables you to use video cameras from Python on Windows";
    homepage = "https://github.com/andreaschiavinato/python_grabber/";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      S0AndS0
    ];
  };
})
