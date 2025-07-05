{
  lib,
  fetchFromGitHub,
  python3,
  installShellFiles,
  fetchpatch,
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "watson";
  version = "2.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "Watson";
    rev = version;
    sha256 = "sha256-/AASYeMkt18KPJljAjNPRYOpg/T5xuM10LJq4LrFD0g=";
  };

  patches = [
    # https://github.com/jazzband/Watson/pull/473
    (fetchpatch {
      name = "fix-completion.patch";
      url = "https://github.com/jazzband/Watson/commit/43ad061a981eb401c161266f497e34df891a5038.patch";
      sha256 = "sha256-v8/asP1wooHKjyy9XXB4Rtf6x+qmGDHpRoHEne/ZCxc=";
    })
  ];

  postInstall = ''
    installShellCompletion --bash --name watson watson.completion
    installShellCompletion --zsh --name _watson watson.zsh-completion
    installShellCompletion --fish watson.fish
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    mock
    pytest-datafiles
  ];
  propagatedBuildInputs = [
    arrow
    click
    click-didyoumean
    requests
  ];
  nativeBuildInputs = [ installShellFiles ];

  meta = with lib; {
    homepage = "https://github.com/jazzband/Watson";
    description = "Wonderful CLI to track your time!";
    mainProgram = "watson";
    license = licenses.mit;
    maintainers = with maintainers; [
      mguentner
      nathyong
      oxzi
    ];
  };
}
