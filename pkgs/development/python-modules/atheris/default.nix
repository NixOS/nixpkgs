{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  llvmPackages,
  pybind11,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "atheris";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "atheris";
    tag = finalAttrs.version;
    hash = "sha256-8+L39z8VV3lG8NBEUajHmhq8mRp3OiiBbeVxl7nHrD0=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pybind11 ];

  postPatch = ''
    patchShebangs setup_utils
  '';

  # Extracted from find_libfuzzer.sh
  env.LIBFUZZER_LIB = "${llvmPackages.compiler-rt}/lib/linux/libclang_rt.fuzzer_no_main-${stdenv.hostPlatform.linuxArch}.a";

  pythonImportsCheck = [ "atheris" ];

  meta = {
    description = "Coverage-guided Python fuzzing engine";
    homepage = "https://github.com/google/atheris";
    changelog = "https://github.com/google/atheris/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
