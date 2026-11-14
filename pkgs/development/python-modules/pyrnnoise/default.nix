{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rnnoise,
  stdenv,
  python,
  setuptools,
  audiolab,
  click,
  matplotlib,
  numpy,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyrnnoise";
  version = "0.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pengzhendong";
    repo = "pyrnnoise";
    rev = "fe603b252ccc7d3bacadb77d6ab766c48acc6fce";
    hash = "sha256-oQa7Se6debpG8Vwsu+gcOCwLdQ+RwfnQCFGrNyekoYc=";
  };

  postPatch = ''
    echo ${finalAttrs.version} > VERSION
    substituteInPlace setup.py \
      --replace-fail "from wheel.bdist_wheel import bdist_wheel" \
        "from setuptools.command.bdist_wheel import bdist_wheel"
    substituteInPlace pyrnnoise/rnnoise.py \
      --replace-fail 'os.path.join(os.path.dirname(__file__), "librnnoise.dylib")' \
        '"${lib.getLib rnnoise}/lib/librnnoise${stdenv.hostPlatform.extensions.sharedLibrary}"' \
      --replace-fail 'os.path.join(os.path.dirname(__file__), "librnnoise.so")' \
        '"${lib.getLib rnnoise}/lib/librnnoise${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    audiolab
    click
    matplotlib
    numpy
    tqdm
  ];

  pythonImportsCheck = [ "pyrnnoise" ];

  installCheckPhase = ''
    runHook preInstallCheck
    ${python.interpreter} - <<'PY'
    import numpy as np
    from pyrnnoise import rnnoise

    assert rnnoise.lib._name == "${lib.getLib rnnoise}/lib/librnnoise${stdenv.hostPlatform.extensions.sharedLibrary}"
    for channels in (1, 2):
        states = [rnnoise.create() for _ in range(channels)]
        assert all(states)
        try:
            rng = np.random.default_rng(0)
            for _ in range(3):
                frame = rng.integers(-10000, 10000, (channels, rnnoise.FRAME_SIZE), dtype=np.int16)
                output, probability = rnnoise.process_frame(states, frame)
                assert output.shape == frame.shape
                assert output.dtype == frame.dtype
                assert np.isfinite(output).all()
                assert np.all((0 <= probability) & (probability <= 1))
        finally:
            for state in states:
                rnnoise.destroy(state)
    PY
    runHook postInstallCheck
  '';

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
