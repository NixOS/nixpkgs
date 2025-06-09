{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  colorama,
}:

buildPythonPackage rec {
  pname = "ansimarkup";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gvalkov";
    repo = "python-ansimarkup";
    tag = "v${version}";
    hash = "sha256-+kZt8tv09RHrMRZtvJPBBiFaeCksXyrlHqIabPrXYDY=";
  };

  build-system = [ setuptools ];

  dependencies = [ colorama ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ansimarkup" ];

  meta = with lib; {
    description = "XML-like markup for producing colored terminal text";
    homepage = "https://github.com/gvalkov/python-ansimarkup";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cpcloud ];
  };
}
