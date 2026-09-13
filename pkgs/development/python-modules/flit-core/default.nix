{
  lib,
  buildPythonPackage,
  flit,
}:

buildPythonPackage (finalAttrs: {
  pname = "flit-core";
  inherit (flit) version;
  pyproject = true;

  inherit (flit) src patches;

  postPatch = "cd flit_core";

  # Tests are run in the "flit" package.
  doCheck = false;

  passthru.tests = {
    inherit flit;
  };

  __structuredAttrs = true;

  meta = {
    description = "Distribution-building parts of Flit. See flit package for more information";
    homepage = "https://github.com/pypa/flit";
    changelog = "https://github.com/pypa/flit/blob/${finalAttrs.src.tag}/doc/history.rst";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.python ];
  };
})
