{ stdenv, fetchurl, pkgconfig
, docSupport ? true, doxygen ? null, graphviz ? null }:

assert docSupport -> doxygen != null && graphviz != null;

stdenv.mkDerivation rec {
  pname = "libsidplayfp";
  major = "1";
  minor = "8";
  level = "7";
  version = "${major}.${minor}.${level}";

  src = fetchurl {
    url = "mirror://sourceforge/sidplay-residfp/${pname}/${major}.${minor}/${pname}-${version}.tar.gz";
    sha256 = "14k1sbdcbhykwfcadq5lbpnm9xp2r7vs7fyi84h72g89y8pjg0da";
  };

  nativeBuildInputs = [ pkgconfig ]
    ++ stdenv.lib.optionals docSupport [ doxygen graphviz ];

  installTargets = [ "install" ]
    ++ stdenv.lib.optionals docSupport [ "doc" ];

  outputs = [ "out" ] ++ stdenv.lib.optionals docSupport [ "doc" ];

  postInstall = stdenv.lib.optionalString docSupport ''
    mkdir -p $doc/share/doc/libsidplayfp
    mv docs/html $doc/share/doc/libsidplayfp/
  '';

  meta = with stdenv.lib; {
    description = "A library to play Commodore 64 music derived from libsidplay2";
    homepage = https://sourceforge.net/projects/sidplay-residfp/;
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ ramkromberg ];
    platforms = with platforms; unix;
  };
}
