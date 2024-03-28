{
  addDriverRunpath,
  autoFixElfFiles,
  makeSetupHook,
}:
makeSetupHook
  {
    name = "auto-add-opengl-runpath-hook";
    propagatedBuildInputs = [
      addDriverRunpath
      autoFixElfFiles
    ];
  }
  ./auto-add-driver-runpath-hook.sh
