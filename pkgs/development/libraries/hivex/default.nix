{ stdenv, fetchurl, pkgconfig, autoreconfHook, makeWrapper
, perlPackages, libxml2 }:

stdenv.mkDerivation rec {
  name = "hivex-${version}";
  version = "1.3.18";

  src = fetchurl {
    url = "http://libguestfs.org/download/hivex/${name}.tar.gz";
    sha256 = "0ibl186l6rd9qj4rqccfwbg1nnx6z07vspkhk656x6zav67ph7la";
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
