{ mkDerivation, lib, extra-cmake-modules, pam, socat, libgcrypt, qtbase, kwallet, }:

mkDerivation {
  name = "kwallet-pam";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ pam socat libgcrypt qtbase kwallet ];
  postPatch = ''
    sed -i pam_kwallet_init -e "s|socat|${lib.getBin socat}/bin/socat|"
  '';
}
