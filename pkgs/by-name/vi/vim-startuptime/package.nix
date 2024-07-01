{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub
}:
let
  pname = "vim-startuptime";
  version = "1.3.2";
in
buildGoModule {
  inherit pname version;
  ldflags = [
    "-s"
    "-w"
  ];

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "vim-startuptime";
    rev = "v${version}";
    hash = "sha256-d6AXTWTUawkBCXCvMs3C937qoRUZmy0qCFdSLcWh0BE=";
  };

  nativeCheckInputs = with pkgs; [
    vim
    neovim
  ];

  vendorHash = null;

  meta = with lib; {
    homepage = "https://github.com/rhysd/vim-startuptime";
    description = "Small Go program for better `vim --startuptime` alternative";
    maintainers = with maintainers; [ _9yokuro ];
    license = licenses.mit;
    mainProgram = "vim-startuptime";
  };
}
