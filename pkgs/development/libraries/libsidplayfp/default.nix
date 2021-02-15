{ stdenv
, lib
, fetchurl
, pkg-config
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
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/sidplay-residfp/${pname}/${majorMinor version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-4Swaenpe6oBVl3aerHCtF0wEXtSo+sto5f4LnBgDp6w=";
  };

  nativeBuildInputs = [ pkg-config ]
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
