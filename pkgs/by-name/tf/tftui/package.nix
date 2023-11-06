{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tftui";
  version = "0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "idoavrah";
    repo = "terraform-tui";
    rev = "refs/tags/v${version}";
    hash = "sha256-7nNR9mueSEoO1sNxazyL4ViiO7e0vlGSINCCyaU/f1s=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "version = \"x.x.x\"" "version = \"${version}\""
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    posthog
    pyperclip
    requests
    textual
  ];

  meta = with lib; {
    description = "A powerful textual GUI that empowers users to effortlessly view and interact with their Terraform state";
    homepage = "https://github.com/idoavrah/terraform-tui";
    changelog = "https://github.com/idoavrah/terraform-tui/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ srounce ];
    mainProgram = "tftui";
  };
}
