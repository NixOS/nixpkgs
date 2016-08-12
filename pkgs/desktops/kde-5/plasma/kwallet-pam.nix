{ plasmaPackage, ecm, pam, socat, libgcrypt
}:

plasmaPackage {
  name = "kwallet-pam";

  nativeBuildInputs = [ ecm ];

  buildInputs = [ pam socat libgcrypt ];

}
