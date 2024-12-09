{ stdenv, lib, fetchFromGitHub, tmux, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "wemux";
  version = "unstable-2021-04-16";

  src = fetchFromGitHub {
    owner = "zolrath";
    repo = "wemux";
    rev = "01c6541f8deceff372711241db2a13f21c4b210c";
    sha256 = "1y962nzvs7sf720pl3wa582l6irxc8vavd0gp4ag4243b2gs4qvm";
  };

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    substituteInPlace wemux \
        --replace tmux ${tmux}/bin/tmux \
        --replace "/usr/local/etc" "/etc"

    substituteInPlace man/wemux.1 --replace "/usr/local/etc" "/etc"

    install -Dm755 wemux -t $out/bin
    installManPage man/wemux.1

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/zolrath/wemux";
    description = "Multi-user tmux made easy";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ bsima ];
    mainProgram = "wemux";
  };
}
