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
}:

buildPythonPackage {
  format = "setuptools";
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

  pythonImportsCheck = [ "dftd3" ];
  doCheck = true;

  # Parameters need to be present in the python site packages directory, but they
  # are originally only present in the fortran package. This is a consequence of
  # building the python bindings separately from the fortran library.
  postInstall = ''
    ln -s ${simple-dftd3}/share/s-dftd3/parameters.toml $out/${python.sitePackages}/dftd3/.
  '';
}
