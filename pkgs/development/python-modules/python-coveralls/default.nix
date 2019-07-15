{ lib, fetchPypi, buildPythonPackage, requests, pyyaml, coverage }:

buildPythonPackage rec {
  pname = "python-coveralls";
  version = "2.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q73x2hccyhlviswv1q0il3d1dprfb4pl7l3kdpi72rh95ccba1q";
  };

  buildInputs = [ requests pyyaml coverage ];

  doCheck = false;

  meta = {
    homepage = http://github.com/z4r/python-coveralls;
    description = "python interface to coveralls.io api";
    maintainers = with lib.maintainers; [ mog ];
    license = lib.licenses.asl20;
  };
}
