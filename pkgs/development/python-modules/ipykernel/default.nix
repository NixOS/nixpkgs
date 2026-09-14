{
  lib,
  stdenv,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  hatchling,
  appnope,
  comm,
  ipython,
  jupyter-client,
  jupyter-core,
  matplotlib-inline,
  nest-asyncio2,
  packaging,
  psutil,
  pyzmq,
  tornado,
  traitlets,

  # Reverse dependency
  sage,
}:

buildPythonPackage (finalAttrs: {
  pname = "ipykernel";
  version = "7.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-msqq+X0WNVFm5Aha/p0iW/vfK371IPnfO+jyskgnXgk=";
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
    nest-asyncio2
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
    changelog = "https://github.com/ipython/ipykernel/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
})
