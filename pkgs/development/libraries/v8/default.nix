{ stdenv, fetchsvn, gyp, readline, python, which }:

assert readline != null;

let
  system = stdenv.system;
  arch = if system == "i686-linux" then "ia32" else if system == "x86_64-linux" || system == "x86_64-darwin" then "x64" else "";
  version = "3.14.5.9";
in

assert arch != "";

stdenv.mkDerivation {
    name = "v8-${version}";

    src = fetchsvn {
      url = "http://v8.googlecode.com/svn/tags/${version}";
      sha256 = "18qp5qp5xrb6f00w01cklz358yrl54pks963f5rwvwz82d8sfyqr";
      name = "v8-${version}-src";
    };

    patches = [ ./fix-GetLocalizedMessage-usage.patch ];

    configurePhase = ''
      mkdir build/gyp
      ln -sv ${gyp}/bin/gyp build/gyp/gyp
    '';

    nativeBuildInputs = [ which ];
    buildInputs = [ readline python ];

    buildFlags = [
      "library=shared"
      "console=readline"
      "${arch}.release"
    ];

    # http://code.google.com/p/v8/issues/detail?id=2149
    NIX_CFLAGS_COMPILE = "-Wno-unused-local-typedefs -Wno-aggressive-loop-optimizations";

    enableParallelBuilding = true;

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/lib
      mv -v out/${arch}.release/d8 $out/bin

      ${if stdenv.system == "x86_64-darwin" then
        "mv -v out/${arch}.release/libv8.dylib $out/lib"
      else
        "mv -v out/${arch}.release/lib.target/libv8.so $out/lib"}
      mv -v include $out/
    '';

    postFixup = if stdenv.isDarwin then ''
      install_name_tool -change /usr/local/lib/libv8.dylib $out/lib/libv8.dylib -change /usr/lib/libgcc_s.1.dylib ${stdenv.gcc.gcc}/lib/libgcc_s.1.dylib $out/bin/d8
      install_name_tool -id $out/lib/libv8.dylib -change /usr/lib/libgcc_s.1.dylib ${stdenv.gcc.gcc}/lib/libgcc_s.1.dylib $out/lib/libv8.dylib
    '' else null;

    meta = with stdenv.lib; {
      description = "V8 is Google's open source JavaScript engine";
      platforms = platforms.linux ++ platforms.darwin;
      license = licenses.bsd3;
    };
}
