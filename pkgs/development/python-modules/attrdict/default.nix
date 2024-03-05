{ lib
, buildPythonPackage
, fetchPypi
, coverage
, pythonOlder
, nose
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "attrdict";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NckGmLVcaDlGCRF3F3qenAcToIYPDgSf69cmSczXe3A=";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    coverage
    nose
  ];

  postPatch = ''
    substituteInPlace attrdict/merge.py \
      --replace "from collections" "from collections.abc"
    substituteInPlace attrdict/mapping.py \
      --replace "from collections" "from collections.abc"
    substituteInPlace attrdict/default.py \
      --replace "from collections" "from collections.abc"
    substituteInPlace attrdict/mixins.py \
      --replace "from collections" "from collections.abc"
  '';

  # Tests are not shipped and source is not tagged
  doCheck = false;

  pythonImportsCheck = [
    "attrdict"
  ];

  meta = with lib; {
    description = "A dict with attribute-style access";
    homepage = "https://github.com/bcj/AttrDict";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
