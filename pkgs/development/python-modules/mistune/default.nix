{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "mistune";
  version = "3.0.2";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "mistune";
    rev = "refs/tags/v${version}";
    hash = "sha256-OoTiqJ7hsFP1Yx+7xW3rL+Yc/O2lCMdhBBbaZucyZXM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mistune" ];

  meta = with lib; {
    changelog = "https://github.com/lepture/mistune/blob/${src.rev}/docs/changes.rst";
    description = "A sane Markdown parser with useful plugins and renderers";
    homepage = "https://github.com/lepture/mistune";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
