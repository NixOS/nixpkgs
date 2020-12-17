{ buildPythonPackage, fetchPypi, lib, jq }:

buildPythonPackage rec {
  pname = "jq";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "62d649c4f6f26ed91810c8db075f5fe05319c3dc99dbebcd2d31b0b697a4592e";
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
