{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fdt";
  version = "0.3.2";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c16ad9558497412b57118724f945f4043dbd5014ce55c238963b0ff47ea0de34";
  };

  meta = with lib; {
    description = "Flattened Device Tree Python Module";
    homepage = "https://github.com/molejar/pyFDT";
    license = licenses.asl20;
    maintainers = with maintainers; [ tilcreator ];
  };
}
