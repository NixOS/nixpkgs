{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "librsync-0.9.7";
  
  src = fetchurl {
    url = mirror://sourceforge/librsync/librsync-0.9.7.tar.gz;
    sha256 = "1mj1pj99mgf1a59q9f2mxjli2fzxpnf55233pc1klxk2arhf8cv6";
  };

  # To allow x86_64 linking to the static lib to make a shared object
  # like for the package 'duplicity'
  CFLAGS="-fPIC";

  meta = {
    homepage = http://librsync.sourceforge.net/;
    license = "LGPLv2+";
    description = "Implementation of the rsync remote-delta algorithm";
  };
}
