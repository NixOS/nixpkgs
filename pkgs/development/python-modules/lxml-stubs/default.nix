{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytest-mypy-plugins,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lxml-stubs";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lxml";
    repo = "lxml-stubs";
    tag = version;
    hash = "sha256-OwaPnCr0vylhdAvMMUfGV6DjZEh7Q71pgMOt66urg5I=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ lxml ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mypy-plugins
  ];

  disabledTests = [
    # Output difference, https://github.com/lxml/lxml-stubs/issues/101
    "etree_element_iterchildren"
  ];

  meta = with lib; {
    description = "Type stubs for the lxml package";
    homepage = "https://github.com/lxml/lxml-stubs";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
