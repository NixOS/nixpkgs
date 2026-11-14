{
  mkPythonMetaPackage,
  opencv4,
}:

mkPythonMetaPackage {
  pname = "opencv-python-headless";
  inherit (opencv4) version;
  dependencies = [ opencv4 ];
  optional-dependencies = opencv4.optional-dependencies or { };
  # No src of its own, the version comes from opencv4
  passthru.updateScript = null;
  meta = {
    inherit (opencv4.meta) description homepage;
  };
}
