{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
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

buildPythonPackage (finalAttrs: {
  pname = "rapidfuzz";
  version = "3.14.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "RapidFuzz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yE0YH7WVjULPoxAp5keYIy5/kzdDxpWyHFSMObtCiXA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython >=3.1.6, <3.3.0" "Cython >=3.1.6"

    # https://github.com/rapidfuzz/RapidFuzz/commit/377d0c0ace35bbb4683180ebf110414dfff11abb
    substituteInPlace tests/distance/test_init.py \
      --replace-fail 'str_len = 2**32' 'str_len = 2**32 - 1'
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
    changelog = "https://github.com/maxbachmann/RapidFuzz/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
