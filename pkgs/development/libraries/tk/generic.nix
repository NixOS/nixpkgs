{ stdenv, lib, src, pkgconfig, tcl, libXft, fontconfig, patches ? []
, enableAqua ? stdenv.isDarwin, darwin
, ... }:

stdenv.mkDerivation {
  name = "tk-${tcl.version}";

  inherit src patches;

  outputs = [ "out" "man" "dev" ];

  setOutputFlags = false;

  preConfigure = ''
    configureFlagsArray+=(--mandir=$man/share/man --enable-man-symlinks)
    cd unix
  '';

  postInstall = ''
    ln -s $out/bin/wish* $out/bin/wish
    cp ../{unix,generic}/*.h $out/include
  '';

  configureFlags = [
    "--with-tcl=${tcl}/lib"
  ] ++ stdenv.lib.optional enableAqua "--enable-aqua";

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ tcl libXft ];
  buildInputs = lib.optional enableAqua (with darwin; with apple_sdk.frameworks; [
      Cocoa cf-private
    ]);

  doCheck = false; # fails. can't find itself

  inherit tcl;

  passthru = rec {
    inherit (tcl) release version;
    libPrefix = "tk${tcl.release}";
    libdir = "lib/${libPrefix}";
  };

  meta = with stdenv.lib; {
    description = "A widget toolkit that provides a library of basic elements for building a GUI in many different programming languages";
    homepage = http://www.tcl.tk/;
    license = licenses.tcltk;
    platforms = platforms.all;
    maintainers = with maintainers; [ lovek323 vrthra ];
  };
}
