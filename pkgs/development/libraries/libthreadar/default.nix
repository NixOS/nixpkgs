{ lib, stdenv, fetchurl }:

with lib;

stdenv.mkDerivation rec {
  version = "1.3.1";
  pname = "libthreadar";

  src = fetchurl {
    url = "mirror://sourceforge/libthreadar/${pname}-${version}.tar.gz";
    sha256 = "0x1kkccy81rcqbhlw88sw7lykp7398vmrvp6f9yy42k9bl4yxn2q";
  };

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--disable-build-html"
  ];

  postInstall = ''
    # Disable html help
    rm -r "$out"/share
  '';

  meta = {
    homepage = "http://libthreadar.sourceforge.net/";
    description = "A C++ library that provides several classes to manipulate threads";
    longDescription = ''
      Libthreadar is a C++ library providing a small set of C++ classes to manipulate
      threads in a very simple and efficient way from your C++ code.
    '';
    maintainers = with maintainers; [ izorkin ];
    license = licenses.lgpl3;
    platforms = platforms.unix;
  };
}
