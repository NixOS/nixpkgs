{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lksctp-tools,
  python,
}:
buildPythonPackage (finalAttrs: {
  pname = "pysctp";
  version = "0.7.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "P1sec";
    repo = "pysctp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CtWS+tuh2+Q9Hr64W6bsPE2v020BpnUJ5FDHblGCcYs=";
  };

  build-system = [ setuptools ];

  dependencies = [ lksctp-tools ];

  pythonImportsCheck = [ "sctp" ];

  # running the tests fails with OSError: [Errno 93] Protocol not supported
  doCheck = false;

  meta = {
    description = "SCTP stack for Python";
    homepage = "https://github.com/P1sec/pysctp";
    changelog = "https://github.com/pycrate-org/pycrate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
