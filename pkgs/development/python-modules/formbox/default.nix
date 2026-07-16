{
  lib,
  buildPythonPackage,
  fetchzip,
  flit-core,
  mistune,
  nh3,
}:

buildPythonPackage rec {
  pname = "formbox";
  version = "1.0.0";
  pyproject = true;

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

  meta = {
    description = "Script to format mbox as HTML/XML";
    mainProgram = "formbox";
    homepage = "https://trong.loang.net/~cnx/formbox";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.McSinyx ];
  };
}
