{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,

  prettytable,
  ply,
  numpy,
}:

buildPythonPackage rec {
  pname = "pycifrw";
  version = "5.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5ja4C+aivhWyFeaezsDAp4Try/7YseO6xLzG5rqadeA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    prettytable
    ply
    numpy
  ];

  pythonImportsCheck = [ "CifFile" ];

  meta = with lib; {
    description = "Library for reading and writing CIF (Crystallographic Information Format) files";
    homepage = "https://pypi.org/project/pycifrw/";
    license = licenses.psfl;
    maintainers = with maintainers; [
      hcenge
      classic-ally
    ];
  };
}
