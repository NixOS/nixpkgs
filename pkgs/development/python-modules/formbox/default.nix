{ lib, buildPythonPackage, pythonOlder, fetchzip, flit-core, mistune, nh3 }:

buildPythonPackage rec {
  pname = "formbox";
  version = "0.4.3";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchzip {
    url = "https://trong.loang.net/~cnx/formbox/snapshot/formbox-${version}.tar.gz";
    hash = "sha256-sRu0otyeYpxot/Fyiz3wyQJsJvl8nsgIVitzT8frxLE=";
  };

  nativeBuildInputs = [ flit-core ];
  propagatedBuildInputs = [ mistune nh3 ];
  doCheck = false; # there's no test
  pythonImportsCheck = [ "formbox" ];

  meta = with lib; {
    description = "A script to format mbox as HTML/XML";
    homepage = "https://trong.loang.net/~cnx/formbox";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.McSinyx ];
  };
}
