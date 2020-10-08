{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "immutables";
  version = "0.14";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y0aqw29g525frdnmv9paljzacpp4s21sadfbca5b137iciwr8d0";
  };

  meta = {
    description = "An immutable mapping type for Python";
    homepage = "https://github.com/MagicStack/immutables";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
