{ mkDerivation, extra-cmake-modules, pam, socat, libgcrypt }:

mkDerivation {
  name = "kwallet-pam";

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [ pam socat libgcrypt ];

}
