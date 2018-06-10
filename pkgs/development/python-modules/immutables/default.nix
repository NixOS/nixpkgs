{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "immutables";
  version = "0.5";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hba0vkqanwfnb5b3rs14bs7schsmczhan5nd93c1i6fzi17glap";
  };

  meta = {
    description = "An immutable mapping type for Python";
    homepage = https://github.com/MagicStack/immutables;
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
