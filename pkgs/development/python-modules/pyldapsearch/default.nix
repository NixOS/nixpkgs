{
  lib,
  buildPythonPackage,
  cffi,
  click,
  fetchFromGitHub,
  hatchling,
  impacket,
  msldap,
  nix-update-script,
  pyasn1,
  pycryptodome,
  rich,
  setuptools,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyldapsearch";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Tw1sm";
    repo = "pyldapsearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-prypaCGS2BpZGqC/3GrJoRhEhU27dsibVOy2rW+/ePs=";
  };

  pythonRelaxDeps = [ "click" ];

  build-system = [ hatchling ];

  dependencies = [
    cffi
    click
    impacket
    msldap
    pyasn1
    pycryptodome
    rich
    setuptools
    typer
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyldapsearch" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for issuing manual LDAP queries which offers bofhound compatible output";
    homepage = "https://github.com/Tw1sm/pyldapsearch";
    changelog = "https://github.com/Tw1sm/pyldapsearch/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pyldapsearch";
  };
})
