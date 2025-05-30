{
  buildPythonPackage,
  simple-dftd3,
  cffi,
  numpy,
  toml,
  qcengine,
  pyscf,
  ase,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (simple-dftd3)
    pname
    version
    src
    meta
    ;

  # pytest is also required for installation, not only testing
  nativeBuildInputs = [ pytestCheckHook ];

  buildInputs = [ simple-dftd3 ];

  propagatedBuildInputs = [
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
}
