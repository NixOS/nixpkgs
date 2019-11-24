{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "immutables";
  version = "0.11";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6850578a0dc6530ac19113cfe4ddc13903df635212d498f176fe601a8a5a4a3";
  };

  meta = {
    description = "An immutable mapping type for Python";
    homepage = https://github.com/MagicStack/immutables;
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
