{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  libarchive,
  pythonOlder,
  setuptools,
  # unrar is non-free software
  useUnrar ? false,
  unrar,
}:

assert useUnrar -> unrar != null;
assert !useUnrar -> libarchive != null;

buildPythonPackage rec {
  pname = "rarfile";
  version = "4.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "markokr";
    repo = "rarfile";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZiwD2LG25fMd4Z+QWsh/x3ceG5QRBH4s/TZDwMnfpNI=";
  };

  prePatch =
    ''
      substituteInPlace rarfile.py \
    ''
    + (
      if useUnrar then
        ''
          --replace 'UNRAR_TOOL = "unrar"' "UNRAR_TOOL = \"${unrar}/bin/unrar\""
        ''
      else
        ''
          --replace 'ALT_TOOL = "bsdtar"' "ALT_TOOL = \"${libarchive}/bin/bsdtar\""
        ''
    )
    + "";

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # The tests only work with the standard unrar package
  doCheck = useUnrar;

  pythonImportsCheck = [ "rarfile" ];

  meta = with lib; {
    description = "RAR archive reader for Python";
    homepage = "https://github.com/markokr/rarfile";
    changelog = "https://github.com/markokr/rarfile/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ ];
  };
}
