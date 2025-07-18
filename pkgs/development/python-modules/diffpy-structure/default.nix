{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  setuptools,
  setuptools-git-versioning,

  numpy,
  pycifrw,
}:

buildPythonPackage rec {
  pname = "diffpy.structure";
  version = "3.3.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "diffpy";
    repo = pname;
    rev = version;
    hash = "sha256-GB/Ps38Dt0saA516ILSNc90N/P5/AK6VeSxotGhoRxA=";
  };

  postPatch = ''
    # Ignore pinned versions
    sed -i "s/\"\(.*\)\(==\|>=\).*\"/\"\1\"/g" pyproject.toml
  '';

  disabled = pythonOlder "3.11";

  build-system = [
    setuptools
    setuptools-git-versioning
  ];

  dependencies = [
    numpy
    pycifrw
  ];

  pythonImportsCheck = [ "diffpy.structure" ];

  meta = with lib; {
    description = "Provides objects for storing atomic coordinates, displacement parameters and other crystal structure data. diffpy.structure supports import and export of structure data in several structure formats such as CIF, PDB, and xyz.";
    homepage = "https://github.com/diffpy/diffpy.structure";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
