{
  lib,
  stdenv,
  fetchurl,
  tclPackages,
  copyDesktopItems,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tkcon";
  version = "2.8";

  src = fetchurl {
    url = "https://chiselapp.com/user/bohagan/repository/TkCon/uv/tkcon-${finalAttrs.version}.tar.gz";
    hash = "sha256-e3tbyFkp4yvM6tqHwoKszbeRztQMGLkigQN690LaTGc=";
  };

  nativeBuildInputs = [ copyDesktopItems ];

  configureFlags = [
    # Do not use the Tcl interpreter store path as an install prefix
    "--exec-prefix=$(out)"

    "--with-tcl=${tclPackages.tcl}/lib"
    "--with-tk=${tclPackages.tk}/lib"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "tkcon";
      desktopName = "tkcon";
      exec = "tkcon";
    })
  ];

  meta = {
    description = "Enhanced Tcl/Tk Console for all Tk platforms";
    homepage = "https://github.com/bohagan1/TkCon";
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "tkcon";
    inherit (tclPackages.tk.meta) platforms;
  };
})
