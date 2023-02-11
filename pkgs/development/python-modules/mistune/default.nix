{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "mistune";
  version = "2.0.4";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ee0a66053e2267aba772c71e06891fa8f1af6d4b01d5e84e267b4570d4d9808";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mistune" ];

  meta = with lib; {
    description = "A sane Markdown parser with useful plugins and renderers";
    homepage = "https://github.com/lepture/mistune";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
