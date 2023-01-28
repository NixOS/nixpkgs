{ stdenv, lib, src, pkg-config, tcl, libXft, patches ? []
, enableAqua ? stdenv.isDarwin, darwin
, ... }:

tcl.mkTclDerivation {
  pname = "tk";
  version = tcl.version;

  inherit src patches;

  outputs = [ "out" "man" "dev" ];

  setOutputFlags = false;

  preConfigure = ''
    configureFlagsArray+=(--mandir=$man/share/man --enable-man-symlinks)
    cd unix
  '';

  postPatch = ''
    for file in $(find library/demos/. -type f ! -name "*.*"); do
      substituteInPlace $file --replace "exec wish" "exec $out/bin/wish"
    done
  '';

  postInstall = ''
    ln -s $out/bin/wish* $out/bin/wish
    cp ../{unix,generic}/*.h $out/include
    ln -s $out/lib/libtk${tcl.release}${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/libtk${stdenv.hostPlatform.extensions.sharedLibrary}
  ''
  + lib.optionalString (stdenv.isDarwin) ''
    cp ../macosx/*.h $out/include
  '';

  configureFlags = [
    "--enable-threads"
  ] ++ lib.optional stdenv.is64bit "--enable-64bit"
    ++ lib.optional enableAqua "--enable-aqua";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optional enableAqua (with darwin.apple_sdk.frameworks; [ Cocoa ]);

  propagatedBuildInputs = [ libXft ];

  enableParallelBuilding = true;

  doCheck = false; # fails. can't find itself

  inherit tcl;

  passthru = rec {
    inherit (tcl) release version;
    libPrefix = "tk${tcl.release}";
    libdir = "lib/${libPrefix}";
  };

  meta = with lib; {
    description = "A widget toolkit that provides a library of basic elements for building a GUI in many different programming languages";
    homepage = "https://www.tcl.tk/";
    license = licenses.tcltk;
    platforms = platforms.all;
    maintainers = with maintainers; [ lovek323 vrthra ];
  };
}
