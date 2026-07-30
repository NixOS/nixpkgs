{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  ipykernel,
  jedi,
  jupyter-core,
  pexpect,
}:

buildPythonPackage (finalAttrs: {
  pname = "metakernel";
  version = "0.32.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-AxmEtMBinBKchhYtJ72N8mTWmTv5Ya7HMP23H6zv3bw=";
  };

  build-system = [ hatchling ];

  dependencies = [
    ipykernel
    jedi
    jupyter-core
    pexpect
  ];

  # Tests hang, so disable
  doCheck = false;

  pythonImportsCheck = [ "metakernel" ];

  meta = {
    description = "Jupyter/IPython Kernel Tools";
    homepage = "https://github.com/Calysto/metakernel";
    changelog = "https://github.com/Calysto/metakernel/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thomasjm ];
  };
})
