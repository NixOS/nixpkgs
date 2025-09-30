{
  lib,
  stdenv,
  fetchFromGitHub,
}:

# To make use of this plugin, need to add
#   programs.zsh.interactiveShellInit = ''
#     source ${pkgs.zsh-command-time}/share/zsh/plugins/command-time/command-time.plugin.zsh
#     ZSH_COMMAND_TIME_COLOR="yellow"
#     ZSH_COMMAND_TIME_MIN_SECONDS=3
#     ZSH_COMMAND_TIME_ECHO=1
#   '';

stdenv.mkDerivation {
  version = "2020-11-15";
  pname = "zsh-command-time";

  src = fetchFromGitHub {
    owner = "popstas";
    repo = "zsh-command-time";
    rev = "803d26eef526bff1494d1a584e46a6e08d25d918";
    hash = "sha256-ndHVFcz+XmUW0zwFq7pBXygdRKyPLjDZNmTelhd5bv8=";
  };

  strictDeps = true;
  dontUnpack = true;

  installPhase = ''
    install -Dm0444 $src/command-time.plugin.zsh --target-directory=$out/share/zsh/plugins/command-time
  '';

  meta = with lib; {
    description = "Plugin that output time: xx after long commands";
    homepage = "https://github.com/popstas/zsh-command-time";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lassulus ];
  };
}
