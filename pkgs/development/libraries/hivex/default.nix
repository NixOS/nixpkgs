{ stdenv, fetchurl, pkgconfig, autoreconfHook, makeWrapper
, perlPackages, libxml2 }:

stdenv.mkDerivation rec {
  name = "hivex-${version}";
  version = "1.3.17";

  src = fetchurl {
    url = "http://libguestfs.org/download/hivex/${name}.tar.gz";
    sha256 = "1nsjijgcpcl6vm7whbbpxqrjycajf7vy0sp5hfg4vmvjmf3lpjqk";
  };

  patches = [ ./hivex-syms.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    autoreconfHook makeWrapper libxml2
  ] ++ (with perlPackages; [ perl IOStringy ]);

  postInstall = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" --prefix "PATH" : "$out/bin"
    done
  '';

  meta = with stdenv.lib; {
    description = "Windows registry hive extraction library";
    license = licenses.lgpl2;
    homepage = https://github.com/libguestfs/hivex;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
  };
}
