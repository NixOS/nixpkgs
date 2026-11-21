{
  mkPythonMetaPackage,
  phonenumbers,
}:

mkPythonMetaPackage {
  pname = "phonenumberslite";
  inherit (phonenumbers) version;
  dependencies = [ phonenumbers ];
  optional-dependencies = phonenumbers.optional-dependencies or { };
  # No src of its own, the version comes from phonenumbers
  passthru.updateScript = null;
  meta = {
    inherit (phonenumbers.meta) changelog description homepage;
  };
}
