{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "hetzner";
  version = "0.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aszlig";
    repo = "hetzner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6si0bdPrM9I4hqyR4ac7l1IsUHp05sAAzfVl4oU8FVo=";
  };

  build-system = [ setuptools ];

  meta = {
    homepage = "https://github.com/RedMoonStudios/hetzner";
    description = "High-level Python API for accessing the Hetzner robot";
    mainProgram = "hetznerctl";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ aszlig ];
  };
})
