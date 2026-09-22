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

  # fix The 'marisa' derivation has version '0.3.1' but .dist-info/METADATA specifies version '0.0.0'.
  postPatch = ''
    substituteInPlace bindings/python/setup.py --replace-fail \
      'setup(name = "marisa",' \
      'setup(name = "marisa", version = "${marisa.version}"',
  '';

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
