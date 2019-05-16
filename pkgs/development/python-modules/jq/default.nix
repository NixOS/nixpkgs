{ buildPythonPackage, fetchPypi, lib, cython, jq }:

buildPythonPackage rec {
  pname = "jq";
  version = "0.1.6";

  srcs = fetchPypi {
    inherit pname version;
    sha256 = "34bdf9f9e49e522e1790afc03f3584c6b57329215ea0567fb2157867d6d6f602";
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
