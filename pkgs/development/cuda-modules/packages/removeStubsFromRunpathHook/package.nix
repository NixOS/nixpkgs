{
  lib,
  addDriverRunpath,
  arrayUtilities,
  autoFixElfFiles,
  makeSetupHook,
}:
makeSetupHook {
  name = "removeStubsFromRunpathHook";
  propagatedBuildInputs = [
    arrayUtilities.getRunpathEntries
    autoFixElfFiles
  ];

  substitutions = {
    driverLinkLib = addDriverRunpath.driverLink + "/lib";
  };

  meta.license = lib.licenses.mit;
} ./removeStubsFromRunpathHook.bash
