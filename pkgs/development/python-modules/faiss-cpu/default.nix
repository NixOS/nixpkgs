{
  mkPythonMetaPackage,
  faiss,
}:

mkPythonMetaPackage {
  pname = "faiss-cpu";
  inherit (faiss) version;
  dependencies = [ faiss ];
  meta = {
    inherit (faiss.meta) description homepage;
  };
}
