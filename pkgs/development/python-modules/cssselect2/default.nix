{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
  tinycss2,
}:

buildPythonPackage rec {
  pname = "cssselect2";
  version = "0.10.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g7DYIO9YnauvaTKJtkfC9bQQ920oX1beupEf+nWnudE=";
  };

  postPatch = ''
    sed -i '/^addopts/d' pyproject.toml
  '';

  build-system = [ flit-core ];

  dependencies = [ tinycss2 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cssselect2" ];

  meta = {
    description = "CSS selectors for Python ElementTree";
    homepage = "https://github.com/Kozea/cssselect2";
    changelog = "https://github.com/Kozea/cssselect2/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ friedow ];
  };
}
