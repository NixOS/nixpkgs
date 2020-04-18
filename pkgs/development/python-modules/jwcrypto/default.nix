{ lib
, buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  pname = "jwcrypto";
  version = "0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "002i60yidafpr642qcxrd74d8frbc4ci8vfysm05vqydcri1zgmd";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  meta = with lib; {
    description = "Implementation of JOSE Web standards";
    homepage = "https://github.com/latchset/jwcrypto";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.costrouc ];
  };
}
