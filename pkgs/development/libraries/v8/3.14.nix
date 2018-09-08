# This old version of V8 is still needed for the R V8 module
{ stdenv, fetchFromGitHub, gyp, readline, python, which, icu, ... }:

assert readline != null;

with stdenv.lib;
let
  version = "3.14.5.10";
  sha256 = "08vhl84166x13b3cbx8y0g99yqx772zd33gawsa1nxqkyrykql6k";

  arch = if stdenv.is64bit then "x64" else "ia32";

in
stdenv.mkDerivation rec {
  name = "v8-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "v8";
    repo = "v8";
    rev = "${version}";
    inherit sha256;
  };
  patchPhase = ''
    sed -i 's,#!/usr/bin/env python,#!${python}/bin/python,' build/gyp_v8
    sed -i 's,#!/usr/bin/python,#!${python}/bin/python,' build/gyp_v8
  '';

  configurePhase = ''
    PYTHONPATH="tools/generate_shim_headers:$PYTHONPATH" \
    PYTHONPATH="$(toPythonPath ${gyp}):$PYTHONPATH" \
      build/gyp_v8 \
        -f make \
        --generator-output="out" \
        -Dflock_index=0 \
        -Dv8_enable_i18n_support=1 \
        -Duse_system_icu=1 \
        -Dconsole=readline \
        -Dcomponent=shared_library \
        -Dv8_target_arch=${arch}
  '';

  nativeBuildInputs = [ which ];
  buildInputs = [ readline python icu ];

  # http://code.google.com/p/v8/issues/detail?id=2149
  NIX_CFLAGS_COMPILE = concatStringsSep " " [
    "-Wno-error=strict-overflow"
    "-Wno-unused-local-typedefs"
    "-Wno-aggressive-loop-optimizations"
  ];

  buildFlags = [
    "LINK=g++"
    "-C out"
    "builddir=$(CURDIR)/Release"
    "BUILDTYPE=Release"
  ];

  postPatch = stdenv.lib.optionalString (!stdenv.cc.isClang) ''
    sed -i build/standalone.gyp -e 's,-Wno-format-pedantic,,g'
  '';

  enableParallelBuilding = true;

  installPhase = ''
    install -vD out/Release/d8 "$out/bin/d8"
    ${if stdenv.hostPlatform.system == "x86_64-darwin" then ''
    install -vD out/Release/lib.target/libv8.dylib "$out/lib/libv8.dylib"
    '' else ''
    install -vD out/Release/lib.target/libv8.so "$out/lib/libv8.so"
    ''}
    cp -vr include "$out/"
  '';

  postFixup = if stdenv.isDarwin then ''
    install_name_tool -change /usr/local/lib/libv8.dylib $out/lib/libv8.dylib -change /usr/lib/libgcc_s.1.dylib ${stdenv.cc.cc.lib}/lib/libgcc_s.1.dylib $out/bin/d8
    install_name_tool -id $out/lib/libv8.dylib -change /usr/lib/libgcc_s.1.dylib ${stdenv.cc.cc.lib}/lib/libgcc_s.1.dylib $out/lib/libv8.dylib
  '' else null;

  meta = with stdenv.lib; {
    description = "Google's open source JavaScript engine";
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
