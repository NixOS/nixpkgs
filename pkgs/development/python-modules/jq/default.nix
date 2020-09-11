{ buildPythonPackage, fetchPypi, lib, jq }:

buildPythonPackage rec {
  pname = "jq";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fe6ce07bc8d209c385d8ba132a2971c69aef015103c46bea87a73a16c5ec147";
  };
  patches = [ ./jq-py-setup.patch ];

  buildInputs = [ jq ];

  meta = {
    description = "Python bindings for jq, the flexible JSON processor";
    homepage = "https://github.com/mwilliamson/jq.py";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ benley ];
  };
}
