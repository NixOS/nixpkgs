{ lib, buildPythonPackage, pythonOlder, fetchFromSourcehut
, ipfs, packaging, tomli }:

buildPythonPackage rec {
  pname = "ipwhl";
  version = "1.1.0";
  format = "flit";
  disabled = pythonOlder "3.6";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = "ipwhl-utils";
    rev = version;
    sha256 = "sha256-YaIYcoUnbiv9wUOFIzGj2sWGbh7NsqRQcqOR2X6+QZA=";
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
