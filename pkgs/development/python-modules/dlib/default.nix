{
  stdenv,
  buildPythonPackage,
  dlib,
  python,
  pytestCheckHook,
  more-itertools,
  sse4Support ? stdenv.hostPlatform.sse4_1Support,
  avxSupport ? stdenv.hostPlatform.avxSupport,
}:

buildPythonPackage {
  inherit (dlib)
    pname
    version
    src
    nativeBuildInputs
    buildInputs
    meta
    ;

  format = "setuptools";

  patches = [ ./build-cores.patch ];

  nativeCheckInputs = [
    pytestCheckHook
    more-itertools
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "more-itertools<6.0.0" "more-itertools" \
      --replace "pytest==3.8" "pytest"
  '';

  setupPyBuildFlags = [
    "--set USE_SSE4_INSTRUCTIONS=${if sse4Support then "yes" else "no"}"
    "--set USE_AVX_INSTRUCTIONS=${if avxSupport then "yes" else "no"}"
  ];

  dontUseCmakeConfigure = true;
}
