{
  mkPythonMetaPackage,
  pycryptodome,
}:

mkPythonMetaPackage {
  pname = "pycryptodomex";
  inherit (pycryptodome) version;
  dependencies = [ pycryptodome ];
}
