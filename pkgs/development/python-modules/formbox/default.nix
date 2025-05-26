{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchzip,
  flit-core,
  mistune,
  nh3,
}:

buildPythonPackage rec {
  pname = "formbox";
  version = "1.0.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchzip {
    url = "https://trong.loang.net/~cnx/formbox/snapshot/formbox-${version}.tar.gz";
    hash = "sha256-YS0hkmEly7SXQvMIPLmqY89ux6E951twAy7iA3K+asA=";
  };

  nativeBuildInputs = [ flit-core ];
  propagatedBuildInputs = [
    mistune
    nh3
  ];
  doCheck = false; # there's no test
  pythonImportsCheck = [ "formbox" ];

  meta = with lib; {
    description = "Script to format mbox as HTML/XML";
    mainProgram = "formbox";
    homepage = "https://trong.loang.net/~cnx/formbox";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.McSinyx ];
  };
}
