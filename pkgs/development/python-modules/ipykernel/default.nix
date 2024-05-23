{
  lib,
  stdenv,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  hatchling,
  pythonOlder,
  appnope,
  comm,
  debugpy,
  ipython,
  jupyter-client,
  jupyter-core,
  matplotlib-inline,
  nest-asyncio,
  packaging,
  psutil,
  pyzmq,
  tornado,
  traitlets,

  # Reverse dependency
  sage,
}:

buildPythonPackage rec {
  pname = "ipykernel";
  version = "6.29.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PUQHAGD5R1rCCSt2ASP63xBdLiSTwkhItmkafE9Cr1w=";
  };

  # debugpy is optional, see https://github.com/ipython/ipykernel/pull/767
  postPatch = ''
    sed -i "/debugpy/d" pyproject.toml
  '';

  nativeBuildInputs = [ hatchling ];

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
  ] ++ lib.optionals stdenv.isDarwin [ appnope ];

  # check in passthru.tests.pytest to escape infinite recursion with ipyparallel
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
    inherit sage;
  };

  meta = {
    description = "IPython Kernel for Jupyter";
    homepage = "https://ipython.org/";
    changelog = "https://github.com/ipython/ipykernel/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.jupyter.members;
  };
}
