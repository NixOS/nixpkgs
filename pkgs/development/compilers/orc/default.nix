{ lib, stdenv, fetchurl, meson, ninja
, gtk-doc ? null, file, docbook_xsl
, buildDevDoc ? gtk-doc != null
}: let
  inherit (lib) optional optionals;
in stdenv.mkDerivation rec {
  pname = "orc";
  version = "0.4.32";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/orc/${pname}-${version}.tar.xz";
    sha256 = "1w0qmyj3v9sb2g7ff39pp38b9850y9hyy0bag26ifrby5f7ksvm6";
  };

  postPatch = lib.optionalString stdenv.isAarch32 ''
    # https://gitlab.freedesktop.org/gstreamer/orc/-/issues/20
    sed -i '/exec_opcodes_sys/d' testsuite/meson.build
  '' + lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
    # This benchmark times out on Hydra.nixos.org
    sed -i '/memcpy_speed/d' testsuite/meson.build
  '';

  outputs = [ "out" "dev" ]
     ++ optional buildDevDoc "devdoc"
  ;
  outputBin = "dev"; # compilation tools

  mesonFlags =
    optional (!buildDevDoc) [ "-Dgtk_doc=disabled" ]
  ;

  nativeBuildInputs = [ meson ninja ]
    ++ optionals buildDevDoc [ gtk-doc file docbook_xsl ]
  ;

  doCheck = true;

  meta = with lib; {
    description = "The Oil Runtime Compiler";
    homepage = "https://gstreamer.freedesktop.org/projects/orc.html";
    # The source code implementing the Marsenne Twister algorithm is licensed
    # under the 3-clause BSD license. The rest is 2-clause BSD license.
    license = with licenses; [ bsd3 bsd2 ];
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
