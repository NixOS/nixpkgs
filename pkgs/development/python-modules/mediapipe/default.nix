{
  lib,
  stdenv,
  autoPatchelfHook,
  bazel_7,
  buildBazelPackage,
  buildPythonPackage,
  fetchFromGitHub,
  jdk_headless,
  libglvnd,
  opencv4,
  patchelf,
  python,
  setuptools,
  wheel,
  absl-py,
  certifi,
  flatbuffers,
  matplotlib,
  nukeReferences,
  numpy,
  opencv-contrib-python,
  perl,
  sounddevice,
}:

let
  pname = "mediapipe";
  version = "1.0.1";
  # MediaPipe 1.0.1 only ships hermetic dependency locks through Python 3.12.
  # PYTHON_BIN_PATH still selects the interpreter and ABI used for the wheel.
  hermeticPythonVersion = "3.12";
  pythonTag = "cp${lib.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
  wheelPlatformTag = "linux_${stdenv.hostPlatform.parsed.cpu.name}";

  src = fetchFromGitHub {
    owner = "google-ai-edge";
    repo = "mediapipe";
    rev = "02d83cb8eb451099dfb24c02a8784ed996a1710c";
    hash = "sha256-YWUvyS5+xBej4qQTP2XA44OKXyaV5JZgVIELdqvcFcI=";
  };

  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "00fcec28592ebb759fbfa229e91b76ca6ffd4886";
    hash = "sha256-WDgW1nK8aY4jhje244czmVuxNOnKZkhbpDmq6M8SHfM=";
  };

  bazelTargets = [
    "//mediapipe/tasks/c:libmediapipe.so"
    "//mediapipe/tasks/metadata:image_segmenter_metadata_schema_py"
    "//mediapipe/tasks/metadata:metadata_schema_py"
    "//mediapipe/tasks/metadata:object_detector_metadata_schema_py"
    "//mediapipe/tasks/metadata:schema_py"
  ];

  bazelBuild = buildBazelPackage {
    name = "${pname}-${version}-wheel";
    inherit src;

    bazel = bazel_7;
    removeLocal = false;
    removeRulesCC = false;

    # TODO: remove these release-specific compatibility patches when upstream's
    # build supports an offline Nix toolchain without source-tree rewrites.
    patches = [
      ./bazel-output-base.patch
      ./nix-build.patch
    ];

    postPatch = ''
      rm .bazelversion
      substituteInPlace setup.py \
        --replace-fail "@version@" "${version}" \
        --replace-fail "@registry@" "${registry}" \
        --replace-fail "@hermeticPythonVersion@" "${hermeticPythonVersion}"
      substituteInPlace third_party/opencv_linux.BUILD \
        --replace-fail "@opencv4@" "${opencv4}"
      substituteInPlace WORKSPACE \
        --replace-fail "@opencv4@" "${opencv4}"
      rm -rf mediapipe/tasks/c/prebuilts
    '';

    nativeBuildInputs = [
      perl
      python
      setuptools
      wheel
    ];

    buildInputs = [
      libglvnd
      opencv4
    ];

    PYTHON_BIN_PATH = python.interpreter;
    JAVA_HOME = jdk_headless.home;
    # Match upstream Linux wheels, which include the OpenGL ES/EGL GPU path.
    MEDIAPIPE_DISABLE_GPU = "0";

    bazelFlags = [
      "--action_env=PYTHON_BIN_PATH=${python.interpreter}"
      "--copt=-DEGL_NO_X11"
      "--copt=-DMEDIAPIPE_OMIT_EGL_WINDOW_BIT"
      "--copt=-DMESA_EGL_NO_X11_HEADERS"
      "--copt=-DTFLITE_GPU_EXTRA_GLES_DEPS"
      "--python_path=${python.interpreter}"
      "--registry=file://${registry}"
      "--repo_env=JAVA_HOME=${jdk_headless.home}"
      "--repo_env=HERMETIC_PYTHON_VERSION=${hermeticPythonVersion}"
    ];

    fetchAttrs = {
      inherit bazelTargets;
      sha256 = "sha256-rDGiQ14WosrTxlllhyKuhAYbWKO3U+oi/fx2diKGR74=";

      preInstall = ''
        chmod -R +w "$bazelOut/external"
        find "$bazelOut/external" -mindepth 1 -maxdepth 1 \
          -name 'local_*' \
          ! -name local_config_cuda \
          ! -name local_config_tensorrt \
          -exec rm -rf {} +
        find "$bazelOut/external" -mindepth 1 -maxdepth 1 \
          -name '@local_*' \
          ! -name '@local_config_cuda.marker' \
          ! -name '@local_config_tensorrt.marker' \
          -exec rm -rf {} +
        rm -rf \
          "$bazelOut/external/linux_opencv" \
          "$bazelOut/external/@linux_opencv.marker" \
          "$bazelOut"/external/*~local_jdk \
          "$bazelOut"/external/*~local_jdk.marker \
          "$bazelOut"/external/*build_bazel_rules_swift_local_config* \
          "$bazelOut"/external/*local_config_shell* \
          "$bazelOut"/external/*aspect_tools_telemetry_report*
        ${nukeReferences}/bin/nuke-refs \
          "$bazelOut/external/local_config_cuda/crosstool/BUILD"
      '';
    };

    buildAttrs = {
      buildPhase = ''
        runHook preBuild
        patch -d "$bazelOut/external/XNNPACK" -p1 < ${./xnnpack-python.patch}
        substituteInPlace "$bazelOut/external/XNNPACK/BUILD.bazel" \
          --replace-fail "@python@" "${python.interpreter}"
        python setup.py bdist_wheel --dist-dir dist
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        cp dist/*.whl "$out/"
        runHook postInstall
      '';
    };
  };

  wheelFile = "${bazelBuild}/${pname}-${version}-${pythonTag}-${pythonTag}-${wheelPlatformTag}.whl";
in
buildPythonPackage {
  inherit pname version;
  format = "wheel";

  src = wheelFile;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    libglvnd
    opencv4
    stdenv.cc.cc.lib
  ];

  dependencies = [
    absl-py
    certifi
    flatbuffers
    matplotlib
    numpy
    opencv-contrib-python
    sounddevice
  ];

  pythonImportsCheck = [ "mediapipe" ];

  installCheckPhase = ''
    runHook preInstallCheck
    ${python.interpreter} - <<'PY'
    import pathlib
    import subprocess

    import mediapipe as mp
    import numpy as np

    data = np.zeros((2, 2, 3), dtype=np.uint8)
    image = mp.Image(image_format=mp.ImageFormat.SRGB, data=data)
    assert np.array_equal(data, image.numpy_view())

    library = pathlib.Path(mp.__file__).parent / "tasks/c/libmediapipe.so"
    needed = set(
        subprocess.check_output(
            ["${lib.getExe patchelf}", "--print-needed", library],
            text=True,
        ).splitlines()
    )
    assert {"libEGL.so.1", "libGLESv2.so.2"} <= needed
    PY
    runHook postInstallCheck
  '';

  MPLCONFIGDIR = "/tmp/matplotlib";

  passthru = {
    inherit bazelBuild;
  };

  meta = {
    description = "On-device machine learning pipelines";
    homepage = "https://github.com/google-ai-edge/mediapipe";
    changelog = "https://pypi.org/project/mediapipe/${version}/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Tenshock ];
    # TODO: enable aarch64-linux after producing its Bazel dependency hash and
    # validating the locally built wheel on that platform.
    platforms = [ "x86_64-linux" ];
  };
}
