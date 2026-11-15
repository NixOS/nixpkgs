{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  installer,
  packageurl-python,
  packaging,
  zipremove,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-sbom";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    pname = "python_sbom";
    inherit (finalAttrs) version;
    hash = "sha256-W2EbVl1pRpJsih9uxjW+7qSYh0WfClQvU1C3e6r7IoE=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies = [
    installer
    (packageurl-python.overridePythonAttrs { nativeCheckInputs = [ ]; })
    packaging
    zipremove
  ];

  pythonImportsCheck = [ "python_sbom" ];

  meta = {
    description = "SBOMs for Python distributions";
    homepage = "https://github.com/tox-dev/python-sbom";
    license = with lib.licenses; [
      mit
      asl20
    ];
  };
})
