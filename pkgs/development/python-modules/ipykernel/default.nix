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
  version = "6.30.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-arsnAWGJZALna5E5T83OXRvl1F9FZnHlCAVy+FBb45s=";
  };

  # debugpy is optional, see https://github.com/ipython/ipykernel/pull/767
  pythonRemoveDeps = [ "debugpy" ];

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    comm
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ appnope ];

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
    teams = [ lib.teams.jupyter ];
  };
}
