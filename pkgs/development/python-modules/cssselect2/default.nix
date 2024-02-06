{ lib
, buildPythonPackage
, flit-core
, pythonOlder
, fetchPypi
, tinycss2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cssselect2";
  version = "0.7.0";
  format = "pyproject";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HM2YTauJ/GiVUEOspOGwPgzynK2YgPbijjunp0sUqlo=";
  };

  postPatch = ''
    sed -i '/^addopts/d' pyproject.toml
  '';

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [ tinycss2 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cssselect2" ];

  meta = with lib; {
    description = "CSS selectors for Python ElementTree";
    homepage = "https://github.com/Kozea/cssselect2";
    license = licenses.bsd3;
  };
}
