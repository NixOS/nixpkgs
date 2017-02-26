{ plasmaPackage, extra-cmake-modules, pam, socat, libgcrypt
}:

plasmaPackage {
  name = "kwallet-pam";

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [ pam socat libgcrypt ];

}
