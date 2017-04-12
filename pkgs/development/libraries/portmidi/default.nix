{ stdenv, fetchurl, unzip, cmake, /*jdk,*/ alsaLib, apple_sdk, openjdk7, CF, Carbon, CoreServices, CoreAudio, CoreMIDI }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "portmidi-${version}";
  version = "217";

  src = fetchurl {
    url = "mirror://sourceforge/portmedia/portmidi-src-${version}.zip";
    sha256 = "03rfsk7z6rdahq2ihy5k13qjzgx757f75yqka88v3gc0pn9ais88";
  };

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
  ];

  # XXX: This is to deactivate Java support.
  patches = singleton (fetchurl rec {
    url = "https://raw.github.com/Rogentos/argent-gentoo/master/media-libs/"
        + "portmidi/files/portmidi-217-cmake-libdir-java-opts.patch";
    sha256 = "1jbjwan61iqq9fqfpq2a4fd30k3clg7a6j0gfgsw87r8c76kqf6h";
  }) ++ optional stdenv.isDarwin ./darwin.patch;

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

  preConfigure = optional stdenv.isDarwin (''
    substituteInPlace ./CMakeLists.txt --replace "i386 ppc x86_64" "x86_64"
    substituteInPlace ./pm_common/CMakeLists.txt --replace "/Developer/SDKs/MacOSX10.5.sdk" \
      "${apple_sdk.sdk}"

  '' +
  concatMapStrings
  (path:
  ''
    substituteInPlace ./${path}/CMakeLists.txt --replace "CoreAudio.framework" \
      "${CoreAudio}/Library/Frameworks/CoreAudio.framework"
    substituteInPlace ./${path}/CMakeLists.txt --replace "CoreFoundation.framework" \
      "${CF}/Library/Frameworks/CoreFoundation.framework"
    substituteInPlace ./${path}/CMakeLists.txt --replace "CoreMIDI.framework" \
      "${CoreMIDI}/Library/Frameworks/CoreMIDI.framework"
    substituteInPlace ./${path}/CMakeLists.txt --replace "CoreServices.framework" \
      "${CoreServices}/Library/Frameworks/CoreServices.framework"
  '') [ "pm_common" "pm_dylib" ]);

  buildInputs = [ unzip cmake /*jdk*/ ]
                ++ optional stdenv.isLinux alsaLib
                ++ optionals stdenv.isDarwin [ Carbon CoreAudio CoreServices CoreMIDI ];

  NIX_LDFLAGS = optionalString stdenv.isDarwin
    "-framework CoreAudio -framework CoreServices -framework CoreMIDI";

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "http://portmedia.sourceforge.net/portmidi/";
    description = "Platform independent library for MIDI I/O";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
