args: with args;

stdenv.mkDerivation {
  name = "kdetoys-4.0rc2";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.97/src/kdetoys-3.97.0.tar.bz2;
    sha256 = "1ga2xlsr7wl7jnc4clzabgyv5wfcjgpfmv6ca99bkz31nr6lddpa";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace];
}
