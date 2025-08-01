{
  libpass,
  mkPythonMetaPackage,
}:

mkPythonMetaPackage {
  pname = "passlib";
  inherit (libpass) version;
  dependencies = [ libpass ];
  optional-dependencies = libpass.optional-dependencies or { };
  meta = {
    inherit (libpass.meta) changelog description homepage;
  };
}
