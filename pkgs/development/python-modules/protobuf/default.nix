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

let
  versionMajor = lib.versions.major protobuf.version;
  versionMinor = lib.versions.minor protobuf.version;
  versionPatch = lib.versions.patch protobuf.version;
in
buildPythonPackage {
  inherit (protobuf) pname src;

  # protobuf 3.21 corresponds with its python library 4.21
  version =
    if lib.versionAtLeast protobuf.version "3.21"
    then "${toString (lib.toInt versionMajor + 1)}.${versionMinor}.${versionPatch}"
    else protobuf.version;

  sourceRoot = "${protobuf.src.name}/python";

  patches = lib.optionals (pythonAtLeast "3.11") [
    (fetchpatch {
      url = "https://github.com/protocolbuffers/protobuf/commit/da973aff2adab60a9e516d3202c111dbdde1a50f.patch";
      stripLen = 2;
      extraPrefix = "";
      hash = "sha256-a/12C6yIe1tEKjsMxcfDAQ4JHolA8CzkN7sNG8ZspPs=";
    })
  ] ++ lib.optionals (lib.versionAtLeast protobuf.version "3.22") [
    # Replace the vendored abseil-cpp with nixpkgs'
    (substituteAll {
      src = ./use-nixpkgs-abseil-cpp.patch;
      abseil_cpp_include_path = "${lib.getDev protobuf.abseil-cpp}/include";
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
    buildPackages."protobuf${lib.versions.major protobuf.version}_${lib.versions.minor protobuf.version}"
  ];

  setupPyGlobalFlags = [ "--cpp_implementation" ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.optionals (lib.versionAtLeast protobuf.version "3.22") [
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

  disabledTestPaths = lib.optionals (lib.versionAtLeast protobuf.version "3.23") [
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
