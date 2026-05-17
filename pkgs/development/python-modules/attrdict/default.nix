{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "attrdict";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NckGmLVcaDlGCRF3F3qenAcToIYPDgSf69cmSczXe3A=";
  };

  postPatch = ''
    substituteInPlace attrdict/merge.py \
      --replace-fail "from collections" "from collections.abc"
    substituteInPlace attrdict/mapping.py \
      --replace-fail "from collections" "from collections.abc"
    substituteInPlace attrdict/default.py \
      --replace-fail "from collections" "from collections.abc"
    substituteInPlace attrdict/mixins.py \
      --replace-fail "from collections" "from collections.abc"
  '';

  build-system = [ setuptools ];

  dependencies = [ six ];

  # Tests are not shipped and source is not tagged
  doCheck = false;

  pythonImportsCheck = [ "attrdict" ];

  meta = {
    description = "Dict with attribute-style access";
    homepage = "https://github.com/bcj/AttrDict";
    changelog = "https://github.com/bcj/AttrDict/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
