{ lib
, buildPythonPackage
, callPackage
, fetchPypi
, hatchling
, pythonOlder
, comm
, ipython
, jupyter-client
, packaging
, psutil
, tornado
, traitlets
}:

buildPythonPackage rec {
  pname = "ipykernel";
  version = "6.21.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bpITSE5M4fsUJn7kNeGPI8w6BjTmNbn7TtRne4Tg/fg=";
  };

  # debugpy is optional, see https://github.com/ipython/ipykernel/pull/767
  postPatch = ''
    sed -i "/debugpy/d" pyproject.toml
  '';

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    comm
    ipython
    jupyter-client
    packaging
    psutil
    tornado
    traitlets
  ];

  # check in passthru.tests.pytest to escape infinite recursion with ipyparallel
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    description = "IPython Kernel for Jupyter";
    homepage = "https://ipython.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
