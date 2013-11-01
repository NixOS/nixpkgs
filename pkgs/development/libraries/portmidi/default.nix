{ stdenv, fetchurl, unzip, cmake, /*openjdk,*/ alsaLib }:

stdenv.mkDerivation rec {
  name = "portmidi-${version}";
  version = "217";

  src = fetchurl {
    url = "mirror://sourceforge/portmedia/portmidi-src-${version}.zip";
    sha256 = "03rfsk7z6rdahq2ihy5k13qjzgx757f75yqka88v3gc0pn9ais88";
  };

  cmakeFlags = let
    #base = "${openjdk}/jre/lib/${openjdk.architecture}";
  in [
    "-DPORTMIDI_ENABLE_JAVA=0"
    /* TODO: Fix Java support.
    "-DJAVA_AWT_LIBRARY=${base}/libawt.so"
    "-DJAVA_JVM_LIBRARY=${base}/server/libjvm.so"
    */
    "-DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=Release"
    "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=Release"
    "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=Release"
  ];

  # XXX: This is to deactivate Java support.
  patches = stdenv.lib.singleton (fetchurl rec {
    url = "https://raw.github.com/Rogentos/argent-gentoo/master/media-libs/"
        + "portmidi/files/portmidi-217-cmake-libdir-java-opts.patch";
    sha256 = "1jbjwan61iqq9fqfpq2a4fd30k3clg7a6j0gfgsw87r8c76kqf6h";
  });

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

  postInstall = ''
    ln -s libportmidi.so "$out/lib/libporttime.so"
  '';

  buildInputs = [ unzip cmake /*openjdk*/ alsaLib ];

  meta = {
    homepage = "http://portmedia.sourceforge.net/portmidi/";
    description = "Platform independent library for MIDI I/O";
    license = stdenv.lib.licenses.mit;
  };
}
