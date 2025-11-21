{
  buildPythonPackage,
  brainflow,
  nptyping,
  numpy,
  python,
  setuptools,
}:

buildPythonPackage {
  inherit (brainflow)
    pname
    version
    src
    patches
    meta
    ;

  pyproject = true;
  build-system = [ setuptools ];

  dependencies = [
    numpy
    nptyping
  ];

  buildInputs = [ brainflow ];

  postPatch = ''
    cd python_package
  '';

  postInstall = ''
    mkdir -p "$out/${python.sitePackages}/brainflow/lib/"
    cp -Tr "${brainflow}/lib" "$out/${python.sitePackages}/brainflow/lib/"
  '';

  pythonImportsCheck = [ "brainflow" ];
}
