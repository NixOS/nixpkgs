{
  buildPythonPackage,
  bencodetools,
  pytestCheckHook,
  setuptools,
}:
buildPythonPackage {
  inherit (bencodetools) pname version src;
  pyproject = true;

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  dontConfigure = true;

  pythonImportsCheck = [
    "bencode"
    "typevalidator"
  ];

  meta = {
    inherit (bencodetools.meta)
      description
      homepage
      license
      maintainers
      ;
  };
}
