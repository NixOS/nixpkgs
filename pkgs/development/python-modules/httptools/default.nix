{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "httptools";
  version = "0.0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e00cbd7ba01ff748e494248183abc6e153f49181169d8a3d41bb49132ca01dfc";
  };

  meta = with lib; {
    description = "A collection of framework independent HTTP protocol utils";
    homepage = https://github.com/MagicStack/httptools;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
