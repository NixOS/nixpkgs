{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "immutables";
  version = "0.12";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12i8r5z0y6ya850fwl2r4hig5hyli8skvjmgylapxa4zbr13fqmc";
  };

  meta = {
    description = "An immutable mapping type for Python";
    homepage = "https://github.com/MagicStack/immutables";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
