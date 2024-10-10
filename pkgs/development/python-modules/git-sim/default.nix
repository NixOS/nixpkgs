{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  installShellFiles,
  gitpython,
  manim,
  opencv4,
  typer,
  pydantic,
  fonttools,
  git-dummy,
}:

buildPythonPackage rec {
  pname = "git-sim";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "initialcommit-com";
    repo = "git-sim";
    rev = "v${version}";
    hash = "sha256-4jHkAlF2SAzHjBi8pmAJ0TKkcLxw+6EdGsXnHZUMILw=";
  };

  pythonRemoveDeps = [ "opencv-python-headless" ];

  propagatedBuildInputs = [
    gitpython
    manim
    opencv4
    typer
    pydantic
    fonttools
    git-dummy
  ];

  # https://github.com/NixOS/nixpkgs/commit/8033561015355dd3c3cf419d81ead31e534d2138
  makeWrapperArgs = [ "--prefix PYTHONWARNINGS , ignore:::pydub.utils:" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd git-sim \
      --bash <($out/bin/git-sim --show-completion bash) \
      --fish <($out/bin/git-sim --show-completion fish) \
      --zsh <($out/bin/git-sim --show-completion zsh)

    ln -s ${git-dummy}/bin/git-dummy $out/bin/
  '';

  meta = with lib; {
    description = "Visually simulate Git operations in your own repos with a single terminal command";
    homepage = "https://initialcommit.com/tools/git-sim";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mathiassven ];
  };
}
