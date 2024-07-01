{
  lib,
  buildPythonPackage,
  pythonOlder,
  git,
  gnupg,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "git-revise";
  version = "0.7.0";
  format = "setuptools";

  # Missing tests on PyPI
  src = fetchFromGitHub {
    owner = "mystor";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xV1Z9O5FO4Q/XEpNwnX31tbv8CrXY+wF1Ltpfq+ITRg=";
  };

  disabled = pythonOlder "3.8";

  nativeCheckInputs = [
    git
    gnupg
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Efficiently update, split, and rearrange git commits";
    homepage = "https://github.com/mystor/git-revise";
    changelog = "https://github.com/mystor/git-revise/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "git-revise";
    maintainers = with maintainers; [ emily ];
  };
}
