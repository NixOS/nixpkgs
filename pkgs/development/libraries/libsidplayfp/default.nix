{ stdenv
, lib
, fetchurl
, pkgconfig
, docSupport ? true
, doxygen ? null
, graphviz ? null
}:

assert docSupport -> doxygen != null && graphviz != null;
let
  inherit (lib) optionals optionalString;
  inherit (lib.versions) majorMinor;
in
stdenv.mkDerivation rec {
  pname = "libsidplayfp";
  version = "2.0.4";

  src = fetchurl {
    url = "mirror://sourceforge/sidplay-residfp/${pname}/${majorMinor version}/${pname}-${version}.tar.gz";
    sha256 = "0d866czmnmhnhb2j37rlrdphjdi2b75kak9barm9xqwg2z0nmmhz";
  };

  nativeBuildInputs = [ pkgconfig ]
    ++ optionals docSupport [ doxygen graphviz ];

  installTargets = [ "install" ]
    ++ optionals docSupport [ "doc" ];

  outputs = [ "out" ]
    ++ optionals docSupport [ "doc" ];

  postInstall = optionalString docSupport ''
    mkdir -p $doc/share/doc/libsidplayfp
    mv docs/html $doc/share/doc/libsidplayfp/
  '';

  meta = with lib; {
    description = "A library to play Commodore 64 music derived from libsidplay2";
    homepage = "https://sourceforge.net/projects/sidplay-residfp/";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ ramkromberg ];
    platforms = with platforms; unix;
  };
}
