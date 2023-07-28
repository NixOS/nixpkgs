{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "mistune";
  version = "3.0.1";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6RIRbBOqCUT53FMNs464j2p3CHqxKPSfhKSPTAXqFjw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mistune" ];

  meta = with lib; {
    changelog = "https://github.com/lepture/mistune/blob/v${version}/docs/changes.rst";
    description = "A sane Markdown parser with useful plugins and renderers";
    homepage = "https://github.com/lepture/mistune";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
