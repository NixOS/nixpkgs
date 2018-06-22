{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "immutables";
  version = "0.6";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "63023fa0cceedc62e0d1535cd4ca7a1f6df3120a6d8e5c34e89037402a6fd809";
  };

  meta = {
    description = "An immutable mapping type for Python";
    homepage = https://github.com/MagicStack/immutables;
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
