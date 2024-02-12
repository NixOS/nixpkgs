{ buildPackages
, buildPythonPackage
, fetchpatch
, isPyPy
, lib
, numpy
, protobuf
, pytestCheckHook
, pythonAtLeast
, substituteAll
, tzdata
}:

assert lib.versionOlder protobuf.version "21" -> throw "Protobuf 21 or newer required";

let
  protobufVersionMajor = lib.versions.major protobuf.version;
  protobufVersionMinor = lib.versions.minor protobuf.version;
in
buildPythonPackage {
  inherit (protobuf) pname src;

  # protobuf 21 corresponds with its python library 4.21
  version = "4.${protobufVersionMajor}.${protobufVersionMinor}";
  format = "setuptools";

  sourceRoot = "${protobuf.src.name}/python";

  patches = lib.optionals (lib.versionAtLeast protobuf.version "22") [
    # Replace the vendored abseil-cpp with nixpkgs'
    (substituteAll {
      src = ./use-nixpkgs-abseil-cpp.patch;
      abseil_cpp_include_path = "${lib.getDev protobuf.abseil-cpp}/include";
    })
  ]
  ++ lib.optionals (pythonAtLeast "3.11" && lib.versionOlder protobuf.version "22") [
    (fetchpatch {
      name = "support-python311.patch";
      url = "https://github.com/protocolbuffers/protobuf/commit/2206b63c4649cf2e8a06b66c9191c8ef862ca519.diff";
      stripLen = 1; # because sourceRoot above
      hash = "sha256-3GaoEyZIhS3QONq8LEvJCH5TdO9PKnOgcQF0GlEiwFo=";
    })
  ];

  prePatch = ''
    if [[ "$(<../version.json)" != *'"python": "'"$version"'"'* ]]; then
      echo "Python library version mismatch. Derivation version: $version, actual: $(<../version.json)"
      exit 1
    fi
  '';

  # Remove the line in setup.py that forces compiling with C++14. Upstream's
  # CMake build has been updated to support compiling with other versions of
  # C++, but the Python build has not. Without this, we observe compile-time
  # errors using GCC.
  #
  # Fedora appears to do the same, per this comment:
  #
  #   https://github.com/protocolbuffers/protobuf/issues/12104#issuecomment-1542543967
  #
  postPatch = ''
    sed -i "/extra_compile_args.append('-std=c++14')/d" setup.py
  '';

  nativeBuildInputs = lib.optional isPyPy tzdata;

  buildInputs = [ protobuf ];

  propagatedNativeBuildInputs = [
    # For protoc of the same version.
    buildPackages."protobuf_${protobufVersionMajor}"
  ];

  setupPyGlobalFlags = [ "--cpp_implementation" ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.optionals (lib.versionAtLeast protobuf.version "22") [
    numpy
  ];

  disabledTests = lib.optionals isPyPy [
    # error message differs
    "testInvalidTimestamp"
    # requires tracemalloc which pypy does not implement
    # https://foss.heptapod.net/pypy/pypy/-/issues/3048
    "testUnknownFieldsNoMemoryLeak"
    # assertion is not raised for some reason
    "testStrictUtf8Check"
  ];

  disabledTestPaths = lib.optionals (lib.versionAtLeast protobuf.version "23") [
    # The following commit (I think) added some internal test logic for Google
    # that broke generator_test.py. There is a new proto file that setup.py is
    # not generating into a .py file. However, adding this breaks a bunch of
    # conflict detection in descriptor_test.py that I don't understand. So let's
    # just disable generator_test.py for now.
    #
    #   https://github.com/protocolbuffers/protobuf/commit/5abab0f47e81ac085f0b2d17ec3b3a3b252a11f1
    #
    "google/protobuf/internal/generator_test.py"
  ];

  pythonImportsCheck = [
    "google.protobuf"
    "google.protobuf.internal._api_implementation" # Verify that --cpp_implementation worked
  ];

  passthru = {
    inherit protobuf;
  };

  meta = with lib; {
    description = "Protocol Buffers are Google's data interchange format";
    homepage = "https://developers.google.com/protocol-buffers/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
