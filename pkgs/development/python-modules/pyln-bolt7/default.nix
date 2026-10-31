{
  lib,
  buildPythonPackage,
  hatchling,
  pyln-proto,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "pyln-bolt7";
  # Defined in contrib/pyln-spec/bolt7/pyproject.toml.
  version = "1.0.246";
  pyproject = true;

  inherit (pyln-proto) src;

  postUnpack = ''
    sourceRoot=$sourceRoot/contrib/pyln-spec/bolt7
  '';

  build-system = [ hatchling ];

  dependencies = [ pyln-proto ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonNamespaces = [ "pyln.spec" ];

  pythonImportsCheck = [ "pyln.spec.bolt7" ];

  meta = {
    description = "BOLT7 Lightning Network node and channel discovery specification";
    homepage = "https://github.com/ElementsProject/lightning/tree/master/contrib/pyln-spec/bolt7";
    license = with lib.licenses; [
      mit
      cc-by-40
    ];
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
