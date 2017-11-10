{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "multipledispatch";
  version = "0.4.9";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bda6abb8188d9abb429bd17ed15bc7433f77f1b05a78cfff761711ed81daa7a2";
  };

  # No tests in archive
  doCheck = false;

  meta = {
    homepage = https://github.com/mrocklin/multipledispatch/;
    description = "A relatively sane approach to multiple dispatch in Python";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}