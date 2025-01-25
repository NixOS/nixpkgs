{
  lib,
  buildPythonPackage,
  fetchPypi,
  jalali-core,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "5.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ja8fSNFFa5oKzHsyxoxm6czLrlQWcvm5ck8nTXgQowc=";
  };

  build-system = [ setuptools ];

  dependencies = [ jalali-core ];

  pythonImportsCheck = [ "jdatetime" ];

  meta = with lib; {
    description = "Jalali datetime binding";
    homepage = "https://github.com/slashmili/python-jalali";
    changelog = "https://github.com/slashmili/python-jalali/blob/v${version}/CHANGELOG.md";
    license = licenses.psfl;
    maintainers = [ ];
  };
}
