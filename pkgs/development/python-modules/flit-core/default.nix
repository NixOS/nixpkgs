{
  lib,
  buildPythonPackage,
  flit,
}:

buildPythonPackage rec {
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

  meta = {
    description = "Distribution-building parts of Flit. See flit package for more information";
    homepage = "https://github.com/pypa/flit";
    changelog = "https://github.com/pypa/flit/blob/${src.rev}/doc/history.rst";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.python ];
  };
}
