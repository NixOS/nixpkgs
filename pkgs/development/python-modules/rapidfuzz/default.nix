{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  clang-tools,
  cmake,
  cython,
  ninja,
  scikit-build-core,
  numpy,
  hypothesis,
  pandas,
  pytestCheckHook,
  rapidfuzz-cpp,
  taskflow,
}:

buildPythonPackage rec {
  pname = "rapidfuzz";
  version = "3.14.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "RapidFuzz";
    tag = "v${version}";
    hash = "sha256-wF7eeSD6GQfN0EOwDvrgjMqN5u2wxXFlktQS7nIKgkU=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/rapidfuzz/RapidFuzz/pull/486
      name = "support-taskflow-4.1.0.patch";
      url = "https://github.com/rapidfuzz/RapidFuzz/commit/76fa54bf8c3f2d24879ca1966ea98bbba7b3c9d6.patch";
      hash = "sha256-hJZtYNLSqK5NgcBAcvrf9NPh3Z0+pSlyy0W+uJ96kBQ=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython >=3.1.6, <3.3.0" "Cython >=3.1.6"
  '';

  build-system = [
    cmake
    cython
    ninja
    scikit-build-core
  ]
  ++ lib.optionals stdenv.cc.isClang [
    clang-tools # provides wrapped clang-scan-deps
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    rapidfuzz-cpp
    taskflow
  ];

  env.RAPIDFUZZ_BUILD_EXTENSION = 1;

  preBuild = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    export CMAKE_ARGS="-DCMAKE_CXX_COMPILER_AR=$AR -DCMAKE_CXX_COMPILER_RANLIB=$RANLIB"
  '';

  optional-dependencies = {
    all = [ numpy ];
  };

  preCheck = ''
    export RAPIDFUZZ_IMPLEMENTATION=cpp
  '';

  nativeCheckInputs = [
    hypothesis
    pandas
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "rapidfuzz.distance"
    "rapidfuzz.fuzz"
    "rapidfuzz.process"
    "rapidfuzz.utils"
  ];

  meta = {
    description = "Rapid fuzzy string matching";
    homepage = "https://github.com/maxbachmann/RapidFuzz";
    changelog = "https://github.com/maxbachmann/RapidFuzz/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
