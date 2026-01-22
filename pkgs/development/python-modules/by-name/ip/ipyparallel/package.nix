{
  lib,
  buildPythonPackage,
  decorator,
  fetchPypi,
  hatchling,
  ipykernel,
  ipython,
  jupyter-client,
  psutil,
  python-dateutil,
  pyzmq,
  tornado,
  tqdm,
  traitlets,
}:

buildPythonPackage rec {
  pname = "ipyparallel";
  version = "9.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2ZLt1pipnUXy2QWa8cmujwhtGu7bPoBDYCmi8o0Gn4M=";
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

  meta = {
    description = "Interactive Parallel Computing with IPython";
    homepage = "https://ipyparallel.readthedocs.io/";
    changelog = "https://github.com/ipython/ipyparallel/blob/${version}/docs/source/changelog.md";
    license = lib.licenses.bsd3;
  };
}
