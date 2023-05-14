{ stdenv, buildPythonPackage, dlib, python, pytest, more-itertools, fetchpatch
, sse4Support ? stdenv.hostPlatform.sse4_1Support
, avxSupport ? stdenv.hostPlatform.avxSupport
}:

buildPythonPackage {
  inherit (dlib) pname version src nativeBuildInputs buildInputs meta;

  patches = [
    ./build-cores.patch

    # Upgrade minimum CMake & C++ requirement. Nixpkgs is sufficiently up-to-date
    # so that is not a problem. Applied to make sure the pybind11 patch applies cleanly.
    (fetchpatch {
      url = "https://github.com/davisking/dlib/commit/29288e5d895b21f5508c15294f1303b367534a63.patch";
      sha256 = "sha256-8GsGOehTFabRf+QOZK6Ek/Xgwp8yLj8UKd7kmneBpXk=";
    })
    # Removes a bunch of broken python tests. Also useful to make sure the pybind11
    # patch applies cleanly.
    (fetchpatch {
      url = "https://github.com/davisking/dlib/commit/a517aaa0bbb0524a1a7be3d6637aa6300c2e1dfe.patch";
      sha256 = "sha256-31/c1ViVPdJ/gQVMV22Nnr01/Yg13s9tPowfh4BedNg=";
    })
    # Upgrade pybind11 to 2.4.0. Relevant to fix Python 3.11 support.
    (fetchpatch {
      url = "https://github.com/davisking/dlib/commit/65bce59a1512cf222dec01d3e0f29b612dd181f5.patch";
      sha256 = "sha256-04TGJdn9p9YhDVZHAU9ncgCyR1vrnRxKkTRDSwOk/fw=";
      excludes = [ ".github/workflows/build_python.yml" ];
    })
  ];

  nativeCheckInputs = [ pytest more-itertools ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "more-itertools<6.0.0" "more-itertools" \
      --replace "pytest==3.8" "pytest"
  '';

  # although AVX can be enabled, we never test with it. Some Hydra machines
  # fail because of this, however their build results are probably used on hardware
  # with AVX support.
  checkPhase = ''
    ${python.interpreter} nix_run_setup test --no USE_AVX_INSTRUCTIONS
  '';

  setupPyBuildFlags = [
    "--set USE_SSE4_INSTRUCTIONS=${if sse4Support then "yes" else "no"}"
    "--set USE_AVX_INSTRUCTIONS=${if avxSupport then "yes" else "no"}"
  ];

  dontUseCmakeConfigure = true;
}
