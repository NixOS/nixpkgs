{ lib
, stdenv
, buildPythonPackage
, callPackage
, fetchPypi
, hatchling
, pythonOlder
, appnope
, comm
, debugpy
, ipython
, jupyter-client
, jupyter-core
, matplotlib-inline
, nest-asyncio
, packaging
, psutil
, pyzmq
, tornado
, traitlets
}:

buildPythonPackage rec {
  pname = "ipykernel";
  version = "6.27.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fV1ZS2aQZUtNKZ7bpehy3Be7c5ao0GCcl8t7ihxgXeY=";
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
    debugpy
    ipython
    jupyter-client
    jupyter-core
    matplotlib-inline
    nest-asyncio
    packaging
    psutil
    pyzmq
    tornado
    traitlets
  ] ++ lib.optionals stdenv.isDarwin [
    appnope
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
    maintainers = with lib.maintainers; [ fridh ] ++ lib.teams.jupyter.members;
  };
}
