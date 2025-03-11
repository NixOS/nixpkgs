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
  version = "5.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yB1YmHF7grYJo84qc/i40yMLDHV+XA3p1rGs/cIk9VE=";
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
