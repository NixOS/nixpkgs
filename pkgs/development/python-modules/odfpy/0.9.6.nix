{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "odfpy";
  version = "0.9.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14880cb34kidqhr4svp374dwcsk5mmlzwi8asxvyvmycy5lzjn74";
  };

  doCheck = false;

  meta = {
    description = "Python API and tools to manipulate OpenDocument files";
    homepage = "https://joinup.ec.europa.eu/software/odfpy/home";
    license = lib.licenses.asl20;
  };
}
