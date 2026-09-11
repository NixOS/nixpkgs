{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-mock,
  pytestCheckHook,
  requests,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "pydiscourse";
  version = "1.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pydiscourse";
    repo = "pydiscourse";
    tag = "v${version}";
    hash = "sha256-KqJ6ag4owG7US5Q4Ygjq263ds1o/JhEJ3bNa8YecYtE=";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "pydiscourse" ];

  meta = {
    description = "Python library for working with Discourse";
    mainProgram = "pydiscoursecli";
    homepage = "https://github.com/pydiscourse/pydiscourse";
    changelog = "https://github.com/pydiscourse/pydiscourse/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Dettorer ];
  };
}
