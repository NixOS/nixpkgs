{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "vim-startuptime";
  version = "1.3.2";

  ldflags = [
    "-s"
    "-w"
  ];

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "vim-startuptime";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d6AXTWTUawkBCXCvMs3C937qoRUZmy0qCFdSLcWh0BE=";
  };

  nativeCheckInputs = with pkgs; [
    vim
    neovim
  ];

  vendorHash = null;

  meta = {
    homepage = "https://github.com/rhysd/vim-startuptime";
    description = "Small Go program for better `vim --startuptime` alternative";
    maintainers = with lib.maintainers; [ _9yokuro ];
    license = lib.licenses.mit;
    mainProgram = "vim-startuptime";
  };
})
