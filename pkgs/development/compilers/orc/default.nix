{ lib
, stdenv
, fetchurl
, meson
, ninja
, file
, docbook_xsl
, gtk-doc ? null
, buildDevDoc ? gtk-doc != null

# for passthru.tests
, gnuradio
, gst_all_1
, qt6
, vips

}: let
  inherit (lib) optional optionals;
in stdenv.mkDerivation rec {
  pname = "orc";
<<<<<<< HEAD
  version = "0.4.34";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/orc/${pname}-${version}.tar.xz";
    sha256 = "sha256-j0ers/CXFx5E64B63Nq9hg+6Lv/TfY08T71fNByt1B8=";
=======
  version = "0.4.33";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/orc/${pname}-${version}.tar.xz";
    sha256 = "sha256-hE5tfbgIb3k/V2GNPUto0p2ZsWA05xQw3zwhz9PDVCo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    optionals (!buildDevDoc) [ "-Dgtk_doc=disabled" ]
  ;

  nativeBuildInputs = [ meson ninja ]
    ++ optionals buildDevDoc [ gtk-doc file docbook_xsl ]
  ;

  # https://gitlab.freedesktop.org/gstreamer/orc/-/issues/41
  doCheck = !(stdenv.isLinux && stdenv.isAarch64 && stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12");

  passthru.tests = {
    inherit (gst_all_1) gst-plugins-good gst-plugins-bad gst-plugins-ugly;
    inherit gnuradio vips;
    qt6-qtmultimedia = qt6.qtmultimedia;
  };

  meta = with lib; {
    description = "The Oil Runtime Compiler";
    homepage = "https://gstreamer.freedesktop.org/projects/orc.html";
<<<<<<< HEAD
    changelog = "https://cgit.freedesktop.org/gstreamer/orc/plain/RELEASE?h=${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # The source code implementing the Marsenne Twister algorithm is licensed
    # under the 3-clause BSD license. The rest is 2-clause BSD license.
    license = with licenses; [ bsd3 bsd2 ];
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
