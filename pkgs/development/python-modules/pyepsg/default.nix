{ buildPythonPackage, lib, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "pyepsg";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ng0k140kzq3xcffi4vy10py4cmwzfy8anccysw3vgn1x30ghzjr";
  };

  propagatedBuildInputs = [ requests ];

  doCheck = false;

  meta = with lib; {
    description = "Simple Python interface to epsg.io";
    license = licenses.lgpl3;
    homepage = https://pyepsg.readthedocs.io/en/latest/;
    maintainers = with maintainers; [ mredaelli ];
  };

}
