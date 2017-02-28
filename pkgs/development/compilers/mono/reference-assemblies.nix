{ stdenv, lib, fetchurl, callPackage, pkgconfig, perl
, gettext, ncurses, zlib
, Foundation, libobjc }:

stdenv.mkDerivation rec {
  name = "mono-reference-assemblies-${version}";
  version = "3.12.1";

  src = fetchurl {
    url = "http://download.mono-project.com/sources/mono/mono-${version}.tar.bz2";
    sha256 = "03dn68vignknzxy1rx75p16qx1ild27hixgvr5mw0j19mx9z332x";
  };

  nativeBuildInputs = [ pkgconfig perl ];

  buildInputs = [ zlib ncurses gettext ]
    ++ lib.optionals stdenv.isDarwin [ Foundation libobjc ];

  # Attempt to fix this error when running "mcs --version":
  # The file /nix/store/xxx-mono-2.4.2.1/lib/mscorlib.dll is an invalid CIL image
  dontStrip = true;

  # Parallel building doesn't work, as shows http://hydra.nixos.org/build/2983601
  enableParallelBuilding = false;

  dontAddPrefix = true;
  configureFlags = [
    # Fix build; doesn't matter for API.
    "--disable-boehm" "--without-sigaltstack" "--disable-system-aot"
  ];

  preConfigure = ''
    configureFlags="--prefix=$PWD/builddir $configureFlags"
  '';

  # Patch all the necessary scripts.
  preBuild = ''
    makeFlagsArray=(INSTALL=`type -tp install`)
    patchShebangs ./
  '';

  postInstall = ''
    for ver in 2.0 3.5 4.0; do
      mkdir -p "$out/lib/mono/''${ver}-api"
      for lib in "builddir/lib/mono/$ver/"*.dll; do
        builddir/bin/mono builddir/lib/mono/4.5/mono-cil-strip.exe "$lib" "$out/lib/mono/''${ver}-api/$(basename "$lib")"
      done
    done
  '';

  meta = with stdenv.lib; {
    homepage = "http://mono-project.com/";
    description = "Cross platform, open source .NET development framework";
    platforms = with platforms; darwin ++ linux;
    maintainers = with maintainers; [ viric thoughtpolice obadz vrthra ];
    license = licenses.free; # Combination of LGPL/X11/GPL ?
  };
}
