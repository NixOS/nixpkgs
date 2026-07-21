{
  stdenv,
  lib,
  virtualglLib,
  pkgsi686Linux,
  makeWrapper,
  vulkan-loader,
  addDriverRunpath,
  usei686VirtualglLib ? stdenv.hostPlatform.system == "x86_64-linux",
}:

stdenv.mkDerivation {
  pname = "virtualgl";
  version = lib.getVersion virtualglLib;

  paths = [ virtualglLib ];
  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin
    for i in ${virtualglLib}/bin/* ${virtualglLib}/bin/.vglrun*; do
      ln -s "$i" $out/bin
    done

    wrapProgram $out/bin/vglrun \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          virtualglLib
          (if usei686VirtualglLib then pkgsi686Linux.virtualglLib else null) # TODO use lib.optional(s) for this

          addDriverRunpath.driverLink

          # Needed for vulkaninfo to work
          vulkan-loader
        ]
      }"
  ''
  + lib.optionalString usei686VirtualglLib ''
    ln -sf ${pkgsi686Linux.virtualglLib}/bin/.vglrun.vars32 $out/bin
  '';

  meta = {
    platforms = lib.platforms.linux;
    inherit (virtualglLib.meta) license;
  };
}
