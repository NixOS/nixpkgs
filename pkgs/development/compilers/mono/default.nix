{ stdenv, lib, fetchurl, fetchpatch, callPackage, cmake, bison, pkgconfig, perl, python2
, gettext, ncurses, zlib, cacert
, Foundation, libobjc
, withX11 ? true, libgdiplus, libX11, libXinerama, cairo, glib, gtk2, gdk_pixbuf, librsvg
, withCUPS ? stdenv.isLinux, cups
, withALSA ? stdenv.isLinux, alsaLib
, withLLVM ? !stdenv.isDarwin
}:

let
  llvm = callPackage ./llvm.nix { };
  reference-assemblies = callPackage ./reference-assemblies.nix {
    inherit libobjc Foundation;
  };
in
stdenv.mkDerivation rec {
  name = "mono-${version}";
  version = "4.8.0.495";

  src = fetchurl {
    url = "http://download.mono-project.com/sources/mono/${name}.tar.bz2";
    sha256 = "1jr0l7g1ffgp6piy28bfdiyrgix9n8fgq6bs8kf5i7am89pjx9kv";
  };

  #nativeBuildInputs = [ bison pkgconfig perl python2 ];
  nativeBuildInputs = [ cmake pkgconfig perl ];

  buildInputs = [ zlib ncurses gettext ]
    ++ lib.optionals withX11 [ libgdiplus libX11 ]
    ++ lib.optionals stdenv.isDarwin [ Foundation libobjc ];

  # Fix mono DLLMap so it can find libraries for winforms apps.
  # Other items in the DLLMap may need to be pointed to their store locations, I don't think this is exhaustive
  # http://www.mono-project.com/docs/advanced/pinvoke/dllmap/
  sedExpressions = lib.concatMapStringsSep " " (x: "-e ${x}") (
    lib.optionals withX11 (
      [ "s,@X11@,${libX11.out}/lib/libX11.so.6,g"
        "s,@XINERAMA@,${libXinerama.out}/lib/libXinerama.so.1,g"
        "s,@libgdiplus_install_loc@,${libgdiplus}/lib/libgdiplus.so.0,g"
      ] ++ lib.optionals stdenv.isLinux [
        "s,@GTKX11@,${gtk2}/lib/libgtk-x11-2.0.so.0,g"
        "s,@GDKX11@,${gtk2}/lib/libgdk-x11-2.0.so.0,g"
        "s,libgdk_pixbuf-2.0.so.0,${gdk_pixbuf}/lib/libgdk_pixbuf-2.0.so.0,g"
        "s,libglib-2.0.so.0,${glib}/lib/libglib-2.0.so.0,g"
        "s,librsvg-2.so.2,${librsvg}/lib/librsvg-2.so.2,g"
        "s,libgobject-2.0.so.0,${glib}/lib/libgobject-2.0.so.0,g"
        "s,libcairo.so.2,${cairo}/lib/libcairo.so.2,g"
      ]
    ) ++ lib.optional withALSA "s,libasound.so.2,${alsaLib}/lib/libasound.so.2,g"
      ++ lib.optional withCUPS "s,libcups.so.2,${cups}/lib/libcups.so.2,g"
  );

  postPatch = lib.optionalString (sedExpressions != "") ''
    sed -i $sedExpressions data/config.in
  '';

  dontUseCmakeConfigure = true;

  # To overcome the bug https://bugzilla.novell.com/show_bug.cgi?id=644723
  dontDisableStatic = true;

  configureFlags = lib.optionals withLLVM [
    "--enable-llvm"
    "--with-llvm=${llvm}"
  ];

  # Attempt to fix this error when running "mcs --version":
  # The file /nix/store/xxx-mono-2.4.2.1/lib/mscorlib.dll is an invalid CIL image
  dontStrip = true;

  enableParallelBuilding = true;

  patches = [
    # We want pkg-config to take priority over the dlls in the Mono framework and the GAC
    # because we control pkg-config
    ./pkgconfig-before-gac.patch
    # Route as much hardcoded libraries through global dllmap as possible.
    (fetchpatch {
      url = "https://github.com/mono/mono/commit/c6de69eb21a14b647fa2d1aab33b9d26d1a1b6a7.patch";
      sha256 = "1y0jvrdn3kh0vvj6w6r4p4apiy251sxrwrzsn04hl3jkpl8cvg17";
    })
    # Use built frameworks instead of pre-built reference assemblies.
    (fetchpatch {
      url = "https://anonscm.debian.org/cgit/pkg-mono/packages/mono.git/patch/?id=3cfd6a21f889eebe24e124c1e96d6d05ed722142";
      sha256 = "1y4y6sks7magxqm34m8ywi6yrgan037nzgkwhrq620sfkddialr4";
    })
  ];

  # Patch all the necessary scripts. Also, if we're using LLVM, we fix the default
  # LLVM path to point into the Mono LLVM build, since it's private anyway.
  preBuild = ''
    makeFlagsArray=(INSTALL=`type -tp install`)
    patchShebangs ./
    substituteInPlace mcs/class/corlib/System/Environment.cs --replace /usr/share "$out/share"
  '' + lib.optionalString withLLVM ''
    substituteInPlace mono/mini/aot-compiler.c --replace "llvm_path = g_strdup (\"\")" "llvm_path = g_strdup (\"${llvm}/bin/\")"
  '';

  postInstall = ''
    # Without this, any Mono application attempting to open an SSL connection will throw with
    # The authentication or decryption has failed.
    # ---> Mono.Security.Protocol.Tls.TlsException: Invalid certificate received from server.
    echo "Updating Mono key store"
    $out/bin/cert-sync ${cacert}/etc/ssl/certs/ca-bundle.crt

    # According to [1], gmcs is just mcs
    # [1] https://github.com/mono/mono/blob/master/scripts/gmcs.in
    ln -s $out/bin/mcs $out/bin/gmcs

    # Use our reference assemblies instead of pre-compiled onces.
    for i in ${reference-assemblies}/lib/mono/*; do
      rm -rf "$out/lib/mono/$(basename "$i")"
      cp -r "$i" $out/lib/mono
    done
    rm -rf $out/lib/mono/4.5-api
  '';

  meta = with stdenv.lib; {
    homepage = "http://mono-project.com/";
    description = "Cross platform, open source .NET development framework";
    platforms = with platforms; darwin ++ linux;
    maintainers = with maintainers; [ viric thoughtpolice obadz vrthra ];
    license = licenses.free; # Combination of LGPL/X11/GPL ?
  };
}
