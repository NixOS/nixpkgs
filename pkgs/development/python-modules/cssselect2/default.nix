{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
  pythonOlder,
  tinycss2,
}:

buildPythonPackage rec {
  pname = "cssselect2";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HM2YTauJ/GiVUEOspOGwPgzynK2YgPbijjunp0sUqlo=";
  };

  postPatch = ''
    sed -i '/^addopts/d' pyproject.toml
  '';

  build-system = [ flit-core ];

  dependencies = [ tinycss2 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cssselect2" ];

  meta = with lib; {
    description = "CSS selectors for Python ElementTree";
    homepage = "https://github.com/Kozea/cssselect2";
    changelog = "https://github.com/Kozea/cssselect2/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
