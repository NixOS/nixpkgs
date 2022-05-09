{ lib
, buildPythonPackage
, fetchPypi
, matchpy
, pytools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pymbolic";
  version = "2022.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tS9FHdC5gD4D3jMgrzt85XIwcAYcbSMcACFvbaQlkBI=";
  };

  propagatedBuildInputs = [
    pytools
  ];

  checkInputs = [
    matchpy
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A package for symbolic computation";
    homepage = "https://documen.tician.de/pymbolic/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
