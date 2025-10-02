{
  lib,
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
  defusedxml,
}:

buildPythonPackage rec {
  pname = "py3amf";
  version = "0.8.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "StdCarrot";
    repo = "Py3AMF";
    tag = "v${version}";
    hash = "sha256-9zuHh5+ggIjv1LcjpBNHy2yh09KsFpxUdGrtKGm94Zg=";
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
