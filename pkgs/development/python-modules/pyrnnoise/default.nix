{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  cmake,
  setuptools,
  wheel,
  audiolab,
  click,
  matplotlib,
  numpy,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyrnnoise";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pengzhendong";
    repo = "pyrnnoise";
    rev = "a4edc697a2f475dcdac14c453d7c06eebbd06b33";
    fetchSubmodules = true;
    hash = "sha256-p1Ki8odwCpSIHksNLv74VNm6232j19vpwDR4DTPP6Vc=";
  };

  rnnoiseModel = fetchurl {
    url = "https://modelscope.cn/models/pengzhendong/rnnoise/resolve/master/rnnoise_data-0a8755f8e2d834eff6a54714ecc7d75f9932e845df35f8b59bc52a7cfe6e8b37.tar.gz";
    hash = "sha256-CodV+OLYNO/2pUcU7MfXX5ky6EXfNfi1m8UqfP5uizc=";
  };

  postPatch = ''
    echo ${finalAttrs.version} > VERSION
    sed -i '/^execute_process($/,/^)/d' CMakeLists.txt
    cp ${finalAttrs.rnnoiseModel} \
      rnnoise/rnnoise_data-0a8755f8e2d834eff6a54714ecc7d75f9932e845df35f8b59bc52a7cfe6e8b37.tar.gz
  '';

  nativeBuildInputs = [ cmake ];

  build-system = [
    setuptools
    wheel
  ];

  dontUseCmakeConfigure = true;

  preBuild = ''
    cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
    cmake --build build --parallel "$NIX_BUILD_CORES"
    cmake --install build
  '';

  dependencies = [
    audiolab
    click
    matplotlib
    numpy
    tqdm
  ];

  pythonImportsCheck = [ "pyrnnoise" ];

  meta = {
    description = "Python bindings for RNNoise";
    homepage = "https://github.com/pengzhendong/pyrnnoise";
    license = [
      lib.licenses.asl20
      lib.licenses.bsd3
    ];
    maintainers = with lib.maintainers; [ Tenshock ];
    platforms = lib.platforms.unix;
  };
})
