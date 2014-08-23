{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "google-gflags-2.0";

  src = fetchurl {
    url = "https://gflags.googlecode.com/files/gflags-2.0.tar.gz";
    sha256 = "1mypfahsfy0piavhf7il2jfs1gq7jp6yarl9sq5hhypj34s5sjnf";
  };

  doCheck = true;

  meta = {
    description = "A C++ library that implements commandline flags processing";
    longDescription = ''
      The gflags package contains a C++ library that implements commandline flags processing.
      As such it's a replacement for getopt().
      It was owned by Google. google-gflags project has been renamed to gflags and maintained by new community.
    '';
    homepage = https://code.google.com/p/gflags/;
    license = stdenv.lib.licenses.bsd3;

    maintainers = [ stdenv.lib.maintainers.linquize ];
    platforms = stdenv.lib.platforms.all;
  };
}
