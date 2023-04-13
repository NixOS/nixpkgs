{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "mistune";
  version = "2.0.5";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AkYRPLJJLbh1xr5Wl0p8iTMzvybNkokchfYxUc7gnTQ=";
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
