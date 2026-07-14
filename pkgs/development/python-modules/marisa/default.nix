{
  lib,
  buildPythonPackage,
  marisa,
  setuptools,
  swig,
}:

buildPythonPackage {
  pname = "marisa";
  inherit (marisa) src version;
  pyproject = true;

  patches = marisa.patches or [ ];

  build-system = [ setuptools ];

  nativeBuildInputs = [ swig ];

  buildInputs = [ marisa ];

  preBuild = ''
    make -C bindings swig-python

    cd bindings/python
  '';

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "marisa" ];

  meta = {
    description = "Python bindings for marisa";
    homepage = "https://github.com/s-yata/marisa-trie";
    license = with lib.licenses; [
      bsd2
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
