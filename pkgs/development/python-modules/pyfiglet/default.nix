{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "0.8.post1";
  pname = "pyfiglet";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6c2321755d09267b438ec7b936825a4910fec696292139e664ca8670e103639";
  };

  doCheck = false;

  meta = with lib; {
    description = "FIGlet in pure Python";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
