{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ipython-genutils";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "ipython_genutils";
    inherit version;
    hash = "sha256-6y4RbnXs751NIo/cZq9UJpr6JqtEYwQuM3hbiHxii6g=";
  };

  patches = [
    (fetchpatch {
      name = "ipython_genutils-denose.patch";
      url = "https://build.opensuse.org/public/source/devel:languages:python:jupyter/python-ipython_genutils/denose.patch?rev=9";
      hash = "sha256-At0aq6rLw/L64Own069m0p/WQm7iDa24fm0SPLLRBdE=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ipython_genutils" ];

  meta = {
    description = "Vestigial utilities from IPython";
    homepage = "https://ipython.org/";
    license = lib.licenses.bsd3;
  };
}
