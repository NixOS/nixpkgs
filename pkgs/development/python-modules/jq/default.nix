{ buildPythonPackage, fetchPypi, lib, cython, jq }:

buildPythonPackage rec {
  pname = "jq";
  version = "0.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b6bb376237133080185ab556ca2a724e8be5b31946eb2053d4a1f17ae9df9a8";
  };
  patches = [ ./jq-py-setup.patch ];

  nativeBuildInputs = [ cython ];

  preBuild = ''
    cython jq.pyx
  '';

  buildInputs = [ jq ];

  meta = {
    description = "Python bindings for jq, the flexible JSON processor";
    homepage = "https://github.com/mwilliamson/jq.py";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ benley ];
  };
}
