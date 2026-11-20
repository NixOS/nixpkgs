{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  libarchive,
  setuptools,
  # unrar is non-free software
  useUnrar ? false,
  unrar,
}:

assert useUnrar -> unrar != null;
assert !useUnrar -> libarchive != null;

buildPythonPackage (finalAttrs: {
  pname = "rarfile";
  version = "4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markokr";
    repo = "rarfile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QhNzpNKOuBF/QEQ9XBXwKudcq4VqJyN/0chT+9uCcKg=";
  };

  prePatch = ''
    substituteInPlace rarfile.py \
  ''
  + (
    if useUnrar then
      ''
        --replace-fail 'UNRAR_TOOL = "unrar"' "UNRAR_TOOL = \"${unrar}/bin/unrar\""
      ''
    else
      ''
        --replace-fail 'BSDTAR_TOOL = "bsdtar"' "BSDTAR_TOOL = \"${libarchive}/bin/bsdtar\""
      ''
  )
  + "";

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # The tests only work with the standard unrar package
  doCheck = useUnrar;

  pythonImportsCheck = [ "rarfile" ];

  meta = {
    description = "RAR archive reader for Python";
    homepage = "https://github.com/markokr/rarfile";
    changelog = "https://github.com/markokr/rarfile/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
})
