{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "hijri-converter";
  version = "2.3.2.post1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mGZXzNg6W+ryM85aIZZFdH6IXEXUgzvSqPobkn+jlXA=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hijri_converter" ];

  meta = with lib; {
    description = "Accurate Hijri-Gregorian date converter based on the Umm al-Qura calendar";
    homepage = "https://github.com/dralshehri/hijri-converter";
    changelog = "https://github.com/dralshehri/hijridate/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
