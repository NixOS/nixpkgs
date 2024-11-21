{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  llvmPackages,
  pybind11,
  pypaInstallHook,
  python,
  setuptoolsBuildHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "atheris";
  version = "2.3.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "google";
    repo = "atheris";
    rev = "refs/tags/${version}";
    hash = "sha256-d5T+0YnHMS9nw8lyIS2TOQhwVJDc5dLp9tlpdoViPSs=";
  };

  postPatch = ''
    patchShebangs setup_utils
  '';

  nativeBuildInputs = [
    pybind11
    pypaInstallHook
    setuptoolsBuildHook
  ];

  pythonImportsCheck = [ "atheris" ];

  env = {
    LIBFUZZER_LIB = lib.concatStrings [
      (lib.getLib llvmPackages.compiler-rt)
      "/lib/"
      (lib.toLower stdenv.hostPlatform.uname.system)
      "/libclang_rt.fuzzer_no_main-"
      stdenv.hostPlatform.uname.processor
      ".a"
    ];
  };

  meta = {
    description = "Coverage-guided fuzzer for Python and Python extensions";
    homepage = "https://github.com/google/atheris";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "atheris";
    platforms = lib.intersectLists python.meta.platforms llvmPackages.compiler-rt.meta.platforms;
    # https://github.com/google/atheris/issues/82
    broken = pythonAtLeast "3.12";
  };
}
