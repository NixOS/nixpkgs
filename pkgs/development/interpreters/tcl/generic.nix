{ stdenv

# Version specific stuff
, release, version, src
, ...
}:

stdenv.mkDerivation {
  pname = "tcl";
  inherit version;

  inherit src;

  outputs = [ "out" "man" ];

  setOutputFlags = false;

  preConfigure = ''
    cd unix
  '';

  configureFlags = [
    "--enable-threads"
    # Note: using $out instead of $man to prevent a runtime dependency on $man.
    "--mandir=${placeholder "out"}/share/man"
    "--enable-man-symlinks"
    # Don't install tzdata because NixOS already has a more up-to-date copy.
    "--with-tzdata=no"
    "tcl_cv_strtod_unbroken=ok"
  ] ++ stdenv.lib.optional stdenv.is64bit "--enable-64bit";

  enableParallelBuilding = true;

  postInstall = let
    dllExtension = stdenv.hostPlatform.extensions.sharedLibrary;
  in ''
    make install-private-headers
    ln -s $out/bin/tclsh${release} $out/bin/tclsh
    ln -s $out/lib/libtcl${release}${dllExtension} $out/lib/libtcl${dllExtension}
  '';

  meta = with stdenv.lib; {
    description = "The Tcl scripting language";
    homepage = https://www.tcl.tk/;
    license = licenses.tcltk;
    platforms = platforms.all;
    maintainers = with maintainers; [ vrthra ];
  };

  passthru = rec {
    inherit release version;
    libPrefix = "tcl${release}";
    libdir = "lib/${libPrefix}";
  };
}
