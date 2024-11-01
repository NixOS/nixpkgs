{
  lib,
  attrs,
  buildPythonPackage,
  click,
  commoncode,
  dockerfile-parse,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "container-inspector";
  version = "33.0.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "container-inspector";
    rev = "refs/tags/v${version}";
    hash = "sha256-bXJ4UIDVhiU0DurEeRiyLlSUrNRgwoMqAxXxGb/CcJs=";
  };

  dontConfigure = true;

  build-system = [ setuptools-scm ];

  propagatedBuildInputs = [
    attrs
    click
    dockerfile-parse
    commoncode
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "container_inspector" ];

  meta = with lib; {
    description = "Suite of analysis utilities and command line tools for container images";
    homepage = "https://github.com/nexB/container-inspector";
    changelog = "https://github.com/nexB/container-inspector/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
