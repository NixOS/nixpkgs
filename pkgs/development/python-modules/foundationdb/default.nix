{
  buildPythonPackage,
  lib,
  foundationdb,
}:

buildPythonPackage {
  pname = "foundationdb";
  version = foundationdb.version;
  format = "setuptools";

  src = foundationdb.pythonsrc;
  unpackCmd = "tar xf $curSrc";

  patchPhase = ''
    substituteInPlace ./fdb/impl.py \
      --replace libfdb_c.so "${foundationdb.lib}/lib/libfdb_c.so"
  '';

  doCheck = false;

  meta = {
    description = "Python bindings for FoundationDB";
    homepage = "https://www.foundationdb.org";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
