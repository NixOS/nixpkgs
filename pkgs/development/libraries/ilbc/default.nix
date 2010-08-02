{ stdenv, msilbc }:

stdenv.mkDerivation {
  name = "ilbc-rfc3951";

# I'm too lazy to extract .c source from rfc3951. So, I'm using autotools stuff
# from linphone project
  src = stdenv.mkDerivation {
    name = "ilbc-rfc3951.tar.gz";
    src = msilbc.src;
    outputHashAlgo = "sha256";
    outputHash = "0f6scsp72bz2ifscd8c0x57ipcxi2i4a9b4nwlnwx7a7a0hrazhj";
    phases = "unpackPhase installPhase";
    installPhase = "cp ilbc-rfc3951.tar.gz \${out}";
  };
}
