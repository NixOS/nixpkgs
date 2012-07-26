{ stdenv, fetchsvn, gyp, readline, python, which }:

assert readline != null;

let
  system = stdenv.system;
  arch = if system == "i686-linux" then "ia32" else if system == "x86_64-linux" || system == "x86_64-darwin" then "x64" else "";
  version = "3.11.10.15";
in

assert arch != "";

stdenv.mkDerivation rec {
    name = "v8-${version}";
    src = fetchsvn {
      url = "http://v8.googlecode.com/svn/tags/${version}";
      sha256 = "0pdw4r6crsb07gshww4kbfbavxgkal8yaxkaggnkz62lrwbcwrwi";
    };

    configurePhase = ''
      mkdir build/gyp
      ln -sv ${gyp}/bin/gyp build/gyp/gyp
    '';

    buildNativeInputs = stdenv.lib.optional (system == "i686-linux") which;
    buildInputs = [ readline python ];

    buildFlags = [
      "library=shared"
      "console=readline"
      "${arch}.release"
    ];

    enableParallelBuilding = true;

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/lib
      mv -v out/${arch}.release/d8 $out/bin
      mv -v out/${arch}.release/lib.target/libv8.so $out/lib
      mv -v include $out/
    '';
}
