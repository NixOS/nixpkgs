{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "python-bidi";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04vybwwgj95sa3g21k8s2mwa3amsm35a8ns63b4hgcx0wjz3s6qs";
  };

  propagatedBuildInputs = [
    six
  ];

  meta = with lib; {
    description = "Pure python implementation of the BiDi layout algorithm";
    homepage = https://github.com/MeirKriheli/python-bidi;
    license = lib.licenses.lgpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
  };
}
