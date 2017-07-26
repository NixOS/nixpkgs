{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  name    = "${pname}-${version}";
  version = "1.9";
  pname   = "libircclient";

  src = fetchurl {
    url    = "mirror://sourceforge/${pname}/${pname}/${version}/${name}.tar.gz";
    sha256 = "0r60i76jh4drjh2jgp5sx71chagqllmkaq49zv67nrhqwvp9ghw1";
  };

  outputs = [ "out" "dev" ];

  configureFlags = [ "--enable-shared" ];

  postPatch = ''
    substituteInPlace src/Makefile.in \
      --replace "@prefix@/include" "@prefix@/include/libircclient" \
      --replace "@libdir@"         "@prefix@/lib" \
      --replace "cp "              "install "
  '';

  meta = with stdenv.lib; {
    description = "A small but extremely powerful library which implements the client IRC protocol";
    homepage    = http://www.ulduzsoft.com/libircclient/;
    license     = licenses.lgpl3;
    maintainers = with maintainers; [ obadz ];
    platforms   = platforms.linux;
  };
}
