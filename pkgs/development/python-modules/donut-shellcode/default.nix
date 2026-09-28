{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "donut-shellcode";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TheWover";
    repo = "donut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gKa7ngq2+r4EYRdwH9AWnJodJjCdppzKch4Ve/4ZPhk=";
  };

  # aplib64.a objects lack .note.GNU-stack; linker marks .so executable-stack, breaking dlopen.
  env.NIX_LDFLAGS = "-z,noexecstack";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "donut" ];

  meta = {
    description = "Module to generate x86, x64, or AMD64+x86 position-independent shellcode";
    homepage = "https://github.com/TheWover/donut";
    changelog = "https://github.com/TheWover/donut/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    platforms = with lib.platforms; i686 ++ x86_64;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
