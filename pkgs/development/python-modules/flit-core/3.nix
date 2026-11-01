{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage (finalAttrs: {
  pname = "flit-core";
  version = "3.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "flit";
    tag = finalAttrs.version;
    hash = "sha256-oWV+KK22+iK99iCOCKCV1OCLq2Ef1bcYRKXT5GHwiL8=";
  };

  postPatch = "cd flit_core";

  # Tests are run in the "flit" package.
  doCheck = false;

  meta = {
    description = "Distribution-building parts of Flit. See flit package for more information";
    homepage = "https://github.com/pypa/flit";
    changelog = "https://github.com/pypa/flit/blob/${finalAttrs.src.tag}/doc/history.rst";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.python ];
  };
})
