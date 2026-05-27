{
  mkPythonMetaPackage,
  phonenumbers,
}:

mkPythonMetaPackage {
  pname = "phonenumberslite";
  inherit (phonenumbers) version;
  dependencies = [ phonenumbers ];
  optional-dependencies = phonenumbers.optional-dependencies or { };
  meta = {
    inherit (phonenumbers.meta) changelog description homepage;
  };
}
