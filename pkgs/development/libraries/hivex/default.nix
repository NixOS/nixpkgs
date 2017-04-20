{ stdenv, fetchurl, pkgconfig, autoreconfHook, makeWrapper
, perl, libxml2, IOStringy }:

stdenv.mkDerivation rec {
  name = "hivex-${version}";
  version = "1.3.14";

  src = fetchurl {
    url = "http://libguestfs.org/download/hivex/${name}.tar.gz";
    sha256 = "0aqv28prjcmc66znw0wgaxjijg5mjm44bgn1iil8a4dlbsgv4p7b";
  };

  patches = [ ./hivex-syms.patch ];

  buildInputs = [
    pkgconfig autoreconfHook makeWrapper
    perl libxml2 IOStringy
  ];

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
