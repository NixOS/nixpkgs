{ mkDerivation, lib, extra-cmake-modules, pam, socat, libgcrypt, qtbase, kwallet, }:

mkDerivation {
  pname = "kwallet-pam";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ pam socat libgcrypt qtbase kwallet ];
  postPatch = ''
    sed -i pam_kwallet_init -e "s|socat|${lib.getBin socat}/bin/socat|"
  '';

  # We get a crash when QT_PLUGIN_PATH is more than 1000 characters.
  # pam_kwallet_init passes its environment to kwalletd5, but
  # wrapQtApps gives our environment a huge QT_PLUGIN_PATH value. We
  # are able to unset it here since kwalletd5 will have its own
  # QT_PLUGIN_PATH.
  postFixup = ''
    wrapProgram $out/libexec/pam_kwallet_init --unset QT_PLUGIN_PATH
  '';

  dontWrapQtApps = true;
}
