{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  impacket,
  netaddr,
  poetry-core,
  pypykatz,
  rich,
}:

buildPythonPackage (finalAttrs: {
  pname = "lsassy";
  version = "3.1.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Hackndo";
    repo = "lsassy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lPbZnoR6qWfVBSRAbTJsKpjBieidNsYgAXI3CXHEt1w=";
  };

  pythonRelaxDeps = [
    "impacket"
    "netaddr"
    "rich"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    impacket
    netaddr
    pypykatz
    rich
  ];

  # Tests require an active domain controller
  doCheck = false;

  pythonImportsCheck = [ "lsassy" ];

  meta = {
    description = "Python module to extract data from Local Security Authority Subsystem Service (LSASS)";
    homepage = "https://github.com/Hackndo/lsassy";
    changelog = "https://github.com/Hackndo/lsassy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "lsassy";
  };
})
