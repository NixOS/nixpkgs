{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  vim,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinyxxd";
  version = "1.3.8";

  src = fetchFromGitHub {
    repo = "tinyxxd";
    owner = "xyproto";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ePLqbcwlqBK/x645Yf5pgHSCtBSd3mqktAHhomxU3dM=";
  };

  nativeBuildInputs = [ installShellFiles ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    installManPage tinyxxd.1

    # Allow using `tinyxxd` as `xxd`. This is similar to the Arch packaging.
    # https://gitlab.archlinux.org/archlinux/packaging/packages/tinyxxd/-/blob/main/PKGBUILD
    ln -s $out/bin/{tiny,}xxd
    ln -s $out/share/man/man1/{tiny,}xxd.1.gz
  '';

  meta = {
    homepage = "https://github.com/xyproto/tinyxxd";
    description = "Drop-in replacement and standalone version of the hex dump utility that comes with ViM";
    license = [
      lib.licenses.mit # or
      lib.licenses.gpl2Only
    ];
    mainProgram = "tinyxxd";
    maintainers = with lib.maintainers; [
      emily
      philiptaron
    ];
    platforms = lib.platforms.unix;

    # If the two `xxd` providers are present, choose this one.
    priority = (vim.xxd.meta.priority or lib.meta.defaultPriority) - 1;
  };
})
