{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  hatchling,

  dask,
  diffpy-structure,
  h5py,
  matplotlib,
  numba,
  numpy,
  pooch,
  pycifrw,
  scipy,
  tqdm,
  typing-extensions,
  matplotlib-scalebar,
}:

buildPythonPackage rec {
  pname = "orix";
  version = "0.13.3";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyxem";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nXLRdv96fkq5ADlgoGzFKJudD+aRH/gdCbipDcqj0x0=";
  };

  postPatch = ''
    # Ignore pinned versions
    sed -i "s/\"\(.*\)\(==\|>=\).*\"/\"\1\"/g" pyproject.toml
  '';

  disabled = pythonOlder "3.10";

  buildInputs = [
    hatchling
  ];

  dependencies = [
    dask
    diffpy-structure
    h5py
    matplotlib
    numba
    numpy
    pooch
    pycifrw
    scipy
    tqdm
    typing-extensions
    matplotlib-scalebar
  ];

  pythonImportsCheck = [ "orix" ];

  meta = with lib; {
    description = "An open-source Python library for analysing orientations and crystal symmetry";
    homepage = "https://github.com/pyxem/orix";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
