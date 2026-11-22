{
  lib,
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
  defusedxml,
}:

buildPythonPackage rec {
  pname = "py3amf";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "StdCarrot";
    repo = "Py3AMF";
    tag = "v${version}";
    hash = "sha256-cRazP6HtE0hjGzdit/XCPuwwLtn7SiKF6pm4lgEkB2I=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    defusedxml
  ];

  pythonImportsCheck = [
    "pyamf"
  ];

  meta = {
    description = "Action Message Format (AMF) support for Python 3";
    homepage = "https://github.com/StdCarrot/Py3AMF";
    changelog = "https://github.com/StdCarrot/Py3AMF/blob/${src.rev}/CHANGES.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zhaofengli ];
  };
}
