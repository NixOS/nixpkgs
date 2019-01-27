{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "immutables";
  version = "0.9";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h7i00x6sdbw62rdipp0kaw1mcrvfipxv0054x1n2r4q4j11q7fp";
  };

  meta = {
    description = "An immutable mapping type for Python";
    homepage = https://github.com/MagicStack/immutables;
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
