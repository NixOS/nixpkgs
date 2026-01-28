{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  fetchPypi,
  python,

  # build-system
  cmake,
  ninja,
  setuptools,

  gitMinimal,
}:

let
  version = "0.14.0";
  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxruntime-extensions";
    tag = "v${version}";
    hash = "sha256-aZI40dALLam8mdgR1Ebcd8he32F6h26HbHFAsHqyaww=";
  };

  # https://github.com/microsoft/onnxruntime-extensions/blob/v<VERSION>/cmake/ext_ortlib.cmake
  onnxruntime-src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxruntime";
    tag = "v1.19.2";
    hash = "sha256-NMwso0t8og4fQqz+er4HX+AuZ/2vdZFeOAO8F7VtWiY=";
  };

  # https://github.com/microsoft/onnxruntime-extensions/blob/v<VERSION>/cmake/externals/gsl.cmake
  gsl-src = fetchFromGitHub {
    owner = "microsoft";
    repo = "gsl";
    tag = "v4.0.0";
    hash = "sha256-cXDFqt2KgMFGfdh6NGE+JmP4R0Wm9LNHM0eIblYe6zU=";
  };

  # https://github.com/microsoft/onnxruntime-extensions/blob/v<VERSION>/cmake/externals/googlere2.cmake
  googlere2-src = fetchFromGitHub {
    owner = "google";
    repo = "re2";
    tag = "2021-06-01";
    hash = "sha256-RykvPctW0YaskmS4a3qE7w7tf1sPlU6jTgEFHlrb5CE=";
  };

  # https://github.com/microsoft/onnxruntime-extensions/blob/v<VERSION>/cmake/externals/dlib.cmake
  dlib-src = fetchFromGitHub {
    owner = "davisking";
    repo = "dlib";
    tag = "v19.24.6";
    hash = "sha256-BpE7ZrtiiaDqwy1G4IHOQBJMr6sAadFbRxsdObs1SIY=";
  };

  # https://github.com/microsoft/onnxruntime-extensions/blob/v<VERSION>/cmake/externals/dr_libs.cmake
  dr-libs-src = fetchFromGitHub {
    owner = "mackron";
    repo = "dr_libs";
    rev = "660795b2834aebb2217c9849d668b6e4bd4ef810";
    hash = "sha256-7OGsfigCTBsUElitjl1diDZTRPaRdIuvEerXkojxkFc=";
  };

  # https://github.com/microsoft/onnxruntime-extensions/blob/v<VERSION>/cmake/externals/sentencepieceproject.cmake
  protobuf-src = stdenv.mkDerivation (finalAttrs: {
    pname = "protobuf-src";
    version = "21.12";

    src = fetchFromGitHub {
      owner = "protocolbuffers";
      repo = "protobuf";
      tag = "v${finalAttrs.version}";
      hash = "sha256-VZQEFHq17UsTH5CZZOcJBKiScGV2xPJ/e6gkkVliRCU=";
    };

    patches = [
      "${src}/cmake/externals/sentencepieceproject_pb.patch"
    ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      cp -rva . $out
    '';
  });

  pythonVersionNoDot = builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  systemToPlatform = {
    "aarch64-linux" = "manylinux_2_17_aarch64.manylinux2014_aarch64";
    "x86_64-linux" = "manylinux_2_17_x86_64.manylinux2014_x86_64";
    "aarch64-darwin" = "macosx_11_0_universal2";
    "x86_64-darwin" = "macosx_11_0_universal2";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "onnxruntime-extensions";
  pyproject = true;

  # inherit version src;
  version = "0.14.0";
  src = fetchPypi {
    pname = "onnxruntime_extensions";
    format = "wheel";
    python = "cp${pythonVersionNoDot}";
    abi = "cp${pythonVersionNoDot}";
    dist = "cp${pythonVersionNoDot}";
    platform = systemToPlatform.${stdenv.hostPlatform.system} or (throw "unsupported system");
    inherit (finalAttrs) version;
    hash = "";
  };

  # patches = [
  #   (replaceVars ./cmake-dont-fetch-dependencies.patch {
  #     inherit
  #       onnxruntime-src
  #       gsl-src
  #       googlere2-src
  #       dlib-src
  #       dr-libs-src
  #       protobuf-src
  #       ;
  #   })
  # ];
  # postPatch = ''
  #   cat cmake/
  # '';

  build-system = [
    cmake
    ninja
    setuptools
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    # TODO remove
    # gitMinimal
  ];

  # buildInputs = [
  #   pkgs.onnxruntime
  # ];

  cmakeFlags = [
    "--trace-expand"
  ];

  pythonImportsCheck = [ "onnxruntime_extensions" ];

  meta = {
    description = "Onnxruntime-extensions: A specialized pre- and post- processing library for ONNX Runtime";
    homepage = "https://github.com/microsoft/onnxruntime-extensions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
