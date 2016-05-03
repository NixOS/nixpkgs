{ stdenv, fetchurl, bison, pkgconfig, glib, gettext, perl, libgdiplus, libX11, callPackage, ncurses, zlib, withLLVM ? false, cacert, Foundation, libobjc }:

let
  llvm     = callPackage ./llvm.nix { };
  llvmOpts = stdenv.lib.optionalString withLLVM "--enable-llvm --enable-llvmloaded --with-llvm=${llvm}";
in
stdenv.mkDerivation rec {
  name = "mono-${version}";
  version = "4.0.4.1";
  src = fetchurl {
    url = "http://download.mono-project.com/sources/mono/${name}.tar.bz2";
    sha256 = "1ydw9l89apc9p7xr5mdzy0h97g2q6v243g82mxswfc2rrqhfs4gd";
  };

  buildInputs =
    [ bison pkgconfig glib gettext perl libgdiplus libX11 ncurses zlib
    ]
    ++ (stdenv.lib.optionals stdenv.isDarwin [ Foundation libobjc ]);

  propagatedBuildInputs = [glib];

  NIX_LDFLAGS = if stdenv.isDarwin then "" else "-lgcc_s" ;

  # To overcome the bug https://bugzilla.novell.com/show_bug.cgi?id=644723
  dontDisableStatic = true;

  # In fact I think this line does not help at all to what I
  # wanted to achieve: have mono to find libgdiplus automatically
  configureFlags = "--x-includes=${libX11.dev}/include --x-libraries=${libX11.out}/lib --with-libgdiplus=${libgdiplus}/lib/libgdiplus.so ${llvmOpts}";

  # Attempt to fix this error when running "mcs --version":
  # The file /nix/store/xxx-mono-2.4.2.1/lib/mscorlib.dll is an invalid CIL image
  dontStrip = true;

  # Parallel building doesn't work, as shows http://hydra.nixos.org/build/2983601
  enableParallelBuilding = false;

  # We want pkg-config to take priority over the dlls in the Mono framework and the GAC
  # because we control pkg-config
  patches = [ ./pkgconfig-before-gac.patch ];

  # Patch all the necessary scripts. Also, if we're using LLVM, we fix the default
  # LLVM path to point into the Mono LLVM build, since it's private anyway.
  preBuild = ''
    makeFlagsArray=(INSTALL=`type -tp install`)
    patchShebangs ./
    substituteInPlace mcs/class/corlib/System/Environment.cs --replace /usr/share "$out/share"
  '' + stdenv.lib.optionalString withLLVM ''
    substituteInPlace mono/mini/aot-compiler.c --replace "llvm_path = g_strdup (\"\")" "llvm_path = g_strdup (\"${llvm}/bin/\")"
  '';

  # Fix mono DLLMap so it can find libX11 and gdiplus to run winforms apps
  # Other items in the DLLMap may need to be pointed to their store locations, I don't think this is exhaustive
  # http://www.mono-project.com/Config_DllMap
  postBuild = ''
    find . -name 'config' -type f | while read i; do
        sed -i "s@libX11.so.6@${libX11.out}/lib/libX11.so.6@g" $i
        sed -i "s@/.*libgdiplus.so@${libgdiplus}/lib/libgdiplus.so@g" $i
    done
  '';

  # Without this, any Mono application attempting to open an SSL connection will throw with 
  # The authentication or decryption has failed.
  # ---> Mono.Security.Protocol.Tls.TlsException: Invalid certificate received from server.
  postInstall = ''
    echo "Updating Mono key store"
    $out/bin/cert-sync ${cacert}/etc/ssl/certs/ca-bundle.crt
  ''
  # According to [1], gmcs is just mcs
  # [1] https://github.com/mono/mono/blob/master/scripts/gmcs.in
  + ''
    ln -s $out/bin/mcs $out/bin/gmcs
  '';

  meta = {
    homepage = http://mono-project.com/;
    description = "Cross platform, open source .NET development framework";
    platforms = with stdenv.lib.platforms; darwin ++ linux;
    maintainers = with stdenv.lib.maintainers; [ viric thoughtpolice obadz ];
    license = stdenv.lib.licenses.free; # Combination of LGPL/X11/GPL ?
  };
}
