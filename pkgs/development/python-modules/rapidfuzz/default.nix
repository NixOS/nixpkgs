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
  version = "3.14.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "RapidFuzz";
    tag = "v${version}";
    hash = "sha256-DOXeZaD21Qsum4brBlMSFcBAUbNEOgCXc6AqEboP1e4=";
  };

  patches = [
    # https://github.com/rapidfuzz/RapidFuzz/pull/463
    (fetchpatch {
      name = "support-taskflow-3.11.0.patch";
      url = "https://github.com/rapidfuzz/RapidFuzz/commit/0ef2a4980c41b852283e6db7a747a1632307c75e.patch";
      hash = "sha256-xb+J3PXwD51lZqIJcTzPJWrT/oqrIXxh1cLp91DhIPg=";
    })
    # https://github.com/rapidfuzz/RapidFuzz/pull/470
    (fetchpatch {
      name = "support-taskflow-4.0.0.patch";
      url = "https://github.com/rapidfuzz/RapidFuzz/commit/4b794e6168d98fff4c518a64c4d809238b17d8fe.patch";
      hash = "sha256-F4gwV4ewcHfR7ptcEVAvbiNFIvXqFCIM/Qk8giv4jAc=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "Cython >=3.1.6, <3.2.0" "Cython >=3.1.6"
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
