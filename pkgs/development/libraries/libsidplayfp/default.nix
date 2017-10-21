{ stdenv, fetchurl, pkgconfig
, docSupport ? true, doxygen ? null, graphviz ? null }:

assert docSupport -> doxygen != null && graphviz != null;

stdenv.mkDerivation rec {
  pname = "libsidplayfp";
  major = "1";
  minor = "8";
  level = "6";
  version = "${major}.${minor}.${level}";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sidplay-residfp/${pname}/${major}.${minor}/${name}.tar.gz";
    sha256 = "0lzivfdq0crmfr01c6f5h883yr7wvagq198xkk3srdmvshhxmwnw";
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
