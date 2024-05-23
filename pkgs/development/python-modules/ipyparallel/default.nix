{
  lib,
  buildPythonPackage,
  decorator,
  entrypoints,
  fetchPypi,
  hatchling,
  ipykernel,
  ipython,
  jupyter-client,
  psutil,
  python-dateutil,
  pythonOlder,
  pyzmq,
  tornado,
  tqdm,
  traitlets,
}:

buildPythonPackage rec {
  pname = "ipyparallel";
  version = "8.8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JATVn4ajqqO9J79rV993e/9cE2PBxuYEA3WdFu1C3Hs=";
  };

  # We do not need the jupyterlab build dependency, because we do not need to
  # build any JS components; these are present already in the PyPI artifact.
  #
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"jupyterlab==4.*",' ""
  '';

  build-system = [ hatchling ];

  dependencies = [
    decorator
    entrypoints
    ipykernel
    ipython
    jupyter-client
    psutil
    python-dateutil
    pyzmq
    tornado
    tqdm
    traitlets
  ];

  # Requires access to cluster
  doCheck = false;

  pythonImportsCheck = [ "ipyparallel" ];

  meta = with lib; {
    description = "Interactive Parallel Computing with IPython";
    homepage = "https://ipyparallel.readthedocs.io/";
    changelog = "https://github.com/ipython/ipyparallel/blob/${version}/docs/source/changelog.md";
    license = licenses.bsd3;
  };
}
