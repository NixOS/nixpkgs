{ lib
, buildPythonPackage
, fetchFromGitHub
, psutil
, pytestCheckHook
}:


buildPythonPackage rec {
  pname = "psutil-home-assistant";
  version = "0.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "psutil-home-assistant";
    rev = "refs/tags/${version}";
    hash = "sha256-6bj1aaa/JYZFVwUAJfxISRoldgTmumCG8WrlKhkb6kM=";
  };

  propagatedBuildInputs = [
    psutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/home-assistant-libs/psutil-home-assistant/releases/tag/${version}";
    description = "Wrapper of psutil that removes reliance on globals";
    homepage = "https://github.com/home-assistant-libs/psutil-home-assistant";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
