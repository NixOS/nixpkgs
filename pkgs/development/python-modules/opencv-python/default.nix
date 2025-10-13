{
  mkPythonMetaPackage,
  opencv4,
}:

mkPythonMetaPackage {
  pname = "opencv-python";
  inherit (opencv4) version;
  dependencies = [ opencv4 ];
  optional-dependencies = opencv4.optional-dependencies or { };
  meta = {
    inherit (opencv4.meta) description homepage;
  };
}
