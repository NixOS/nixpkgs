{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "zig-shell-completions";
  version = "unstable-2023-08-17";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = "shell-completions";
    rev = "de9f83166d792cce6a0524e63d2755952dd9872c";
    hash = "sha256-92n41/AWbHYkXiBtbWw+hXZKJCE7KW9igd8cLSBQfHo=";
  };

  nativeBuildInputs = [ installShellFiles ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    installShellCompletion --bash --name zig.bash _zig.bash
    installShellCompletion --zsh --name _zig _zig

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/ziglang/shell-completions";
    description = "Shell completions for the Zig compiler";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
    platforms = platforms.all;
  };
}
