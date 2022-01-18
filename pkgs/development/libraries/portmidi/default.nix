{ lib, stdenv, fetchurl, unzip, cmake, /*jdk,*/ alsa-lib, Carbon, CoreAudio, CoreFoundation, CoreMIDI, CoreServices }:

stdenv.mkDerivation rec {
  pname = "portmidi";
  version = "234";

  src = fetchurl {
    url = "mirror://sourceforge/portmedia/portmedia-code-r${version}.zip";
    sha256 = "1g7i8hgarihycadbgy2f7lifiy5cbc0mcrcazmwnmbbh1bqx6dyp";
  };

  prePatch = ''
    cd portmidi/trunk
  '';

  cmakeFlags = let
    #base = "${jdk}/jre/lib/${jdk.architecture}";
  in [
    "-DPORTMIDI_ENABLE_JAVA=0"
    /* TODO: Fix Java support.
    "-DJAVA_AWT_LIBRARY=${base}/libawt.so"
    "-DJAVA_JVM_LIBRARY=${base}/server/libjvm.so"
    */
    "-DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=Release"
    "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=Release"
    "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=Release"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DCMAKE_OSX_ARCHITECTURES=${if stdenv.isAarch64 then "arm64" else "x86_64"}"
    "-DCOREAUDIO_LIB=${CoreAudio}"
    "-DCOREFOUNDATION_LIB=${CoreFoundation}"
    "-DCOREMIDI_LIB=${CoreMIDI}"
    "-DCORESERVICES_LIB=${CoreServices}"
  ];

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin [
    "-framework CoreAudio"
    "-framework CoreFoundation"
    "-framework CoreMIDI"
    "-framework CoreServices"
  ];

  patches = [
    # XXX: This is to deactivate Java support.
    (fetchurl {
      url = "https://raw.github.com/Rogentos/argent-gentoo/master/media-libs/portmidi/files/portmidi-217-cmake-libdir-java-opts.patch";
      sha256 = "1jbjwan61iqq9fqfpq2a4fd30k3clg7a6j0gfgsw87r8c76kqf6h";
    })
  ] ++ lib.optionals stdenv.isDarwin [
    # Remove hardcoded variables so we can set them properly
    ./remove-darwin-variables.diff
  ];

  postPatch = ''
    sed -i -e 's|/usr/local/|'"$out"'|' -e 's|/usr/share/|'"$out"'/share/|' \
      pm_common/CMakeLists.txt pm_dylib/CMakeLists.txt pm_java/CMakeLists.txt
    sed -i \
        -e 's|-classpath .|-classpath '"$(pwd)"'/pm_java|' \
        -e 's|pmdefaults/|'"$(pwd)"'/pm_java/&|g' \
        -e 's|jportmidi/|'"$(pwd)"'/pm_java/&|g' \
        -e 's/WORKING_DIRECTORY pm_java//' \
        pm_java/CMakeLists.txt
  '';

  postInstall = let ext = stdenv.hostPlatform.extensions.sharedLibrary; in ''
    ln -s libportmidi${ext} "$out/lib/libporttime${ext}"
  '';

  nativeBuildInputs = [ unzip cmake ];
  buildInputs = lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    Carbon CoreAudio CoreFoundation CoreMIDI CoreServices
  ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "http://portmedia.sourceforge.net/portmidi/";
    description = "Platform independent library for MIDI I/O";
    license = licenses.mit;
    maintainers = with maintainers; [ angustrau ];
    platforms = platforms.unix;
  };
}
