{ lib, buildPythonPackage, pythonOlder, fetchFromSourcehut
, ipfs, packaging, tomli }:

buildPythonPackage rec {
  pname = "ipwhl";
  version = "1.0.0";
  format = "flit";
  disabled = pythonOlder "3.6";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = "ipwhl-utils";
    rev = version;
    sha256 = "sha256-KstwdmHpn4ypBNpX56NeStqdzy5RElMTW1oR2hCtJ7c=";
  };

  buildInputs = [ ipfs ];
  propagatedBuildInputs = [ packaging tomli ];
  doCheck = false; # there's no test
  pythonImportsCheck = [ "ipwhl" ];

  meta = with lib; {
    description = "Utilities for the InterPlanetary Wheels";
    homepage = "https://git.sr.ht/~cnx/ipwhl-utils";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.McSinyx ];
  };
}
