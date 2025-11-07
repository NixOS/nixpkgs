{
  addDriverRunpath,
  arrayUtilities,
  autoFixElfFiles,
  makeSetupHook,
}:
makeSetupHook {
  name = "removeStubsFromRunpathHook";
  propagatedBuildInputs = [
    arrayUtilities.getRunpathEntries
    # TODO(@connorbaker): autoFixElfFiles does not propagate a dependency on patchelf despite requiring it.
    # Thankfully, getRunpathEntries does.
    autoFixElfFiles
  ];

  substitutions = {
    driverLinkLib = addDriverRunpath.driverLink + "/lib";
  };
} ./removeStubsFromRunpathHook.bash
