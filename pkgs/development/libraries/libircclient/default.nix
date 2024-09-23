{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.10";
  pname   = "libircclient";

  src = fetchurl {
    url    = "mirror://sourceforge/${pname}/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "0b9wa0h3xc31wpqlvgxgnvqp5wgx3kwsf5s9432m5cj8ycx6zcmv";
  };

  outputs = [ "out" "dev" ];

  configureFlags = [ "--enable-shared" ];

  postPatch = ''
    substituteInPlace src/Makefile.in \
      --replace "@prefix@/include" "@prefix@/include/libircclient" \
      --replace "@libdir@"         "@prefix@/lib" \
      --replace "cp "              "install "
  '';

  meta = with lib; {
    description = "Small but extremely powerful library which implements the client IRC protocol";
    homepage    = "http://www.ulduzsoft.com/libircclient/";
    license     = licenses.lgpl3;
    maintainers = with maintainers; [ obadz ];
    platforms   = platforms.linux;
  };
}
