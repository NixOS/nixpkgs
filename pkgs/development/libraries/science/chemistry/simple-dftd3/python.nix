{
  buildPythonPackage,
  python,
  simple-dftd3,
  cffi,
  numpy,
  toml,
  qcengine,
  pyscf,
  ase,
  pytestCheckHook,
  meson-python,
  meson,
  setuptools,
  pkg-config,
}:

buildPythonPackage {
  inherit (simple-dftd3)
    pname
    version
    src
    meta
    ;

  pyproject = true;

  build-system = [
    meson-python
    meson
    setuptools
  ];

  nativeBuildInputs = [
    pkg-config
    pytestCheckHook
  ];

  buildInputs = [ simple-dftd3 ];

  dependencies = [
    cffi
    numpy
    toml
  ];

  checkInputs = [
    ase
    qcengine
    pyscf
  ];

  preConfigure = ''
    cd python
  '';

  # The compiled CFFI is not placed correctly before pytest invocation
  preCheck = ''
    find . -name "_libdftd3*" -exec cp {} ./dftd3/. \;
  '';

  pythonImportsCheck = [ "dftd3" ];
  doCheck = true;

  # Parameters need to be present in the python site packages directory, but they
  # are originally only present in the fortran package. This is a consequence of
  # building the python bindings separately from the fortran library.
  postInstall = ''
    ln -s ${simple-dftd3}/share/s-dftd3/parameters.toml $out/${python.sitePackages}/dftd3/.
  '';
}
