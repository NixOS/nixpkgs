{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  setuptools,
  standard-telnetlib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ndms2-client";
  version = "0.1.3";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "foxel";
    repo = "python_ndms2_client";
    rev = version;
    hash = "sha256-A19olC1rTHTy0xyeSP45fqvv9GUynQSrMgXBgW8ySOs=";
  };

  dependencies = lib.optionals (pythonAtLeast "3.13") [ standard-telnetlib ];

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ndms2_client" ];

  meta = with lib; {
    description = "Keenetic NDMS 2.x and 3.x client";
    homepage = "https://github.com/foxel/python_ndms2_client";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
