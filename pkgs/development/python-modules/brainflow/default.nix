{
  buildPythonPackage,
  brainflow,
  numpy,
  python,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  inherit (brainflow)
    pname
    version
    src
    patches
    meta
    ;

  pyproject = true;
  build-system = [ setuptools ];

  dependencies = [ numpy ];

  buildInputs = [ brainflow ];

  postPatch = ''
    cd python_package
    substituteInPlace setup.py --replace-fail "version='0.0.1'" "version='${finalAttrs.version}'"
  '';

  postInstall = ''
    mkdir -p "$out/${python.sitePackages}/brainflow/lib/"
    cp -Tr "${brainflow}/lib" "$out/${python.sitePackages}/brainflow/lib/"
  '';

  pythonImportsCheck = [ "brainflow" ];
})
