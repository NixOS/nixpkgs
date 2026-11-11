{
  lib,
  buildPythonPackage,
  fetchFromSourcehut,
  flit-core,
}:

buildPythonPackage rec {
  pname = "loca";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = "loca";
    rev = version;
    hash = "sha256-D/FkukYDAqwwa412lFKVoDb9f+BO/yzDtwE1PniN0tA=";
  };

  nativeBuildInputs = [ flit-core ];

  doCheck = false; # all checks are static analyses
  pythonImportsCheck = [ "loca" ];

  meta = {
    description = "Local locations";
    homepage = "https://pypi.org/project/loca";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.McSinyx ];
  };
}
