{ stdenv, fetchurl, gyp, readline, python, which, icu }:

assert readline != null;

let
  arch = if stdenv.is64bit then "x64" else "ia32";
in

stdenv.mkDerivation rec {
  name = "v8-${version}";
  version = "3.26.31.15";

  src = fetchurl {
    url = "https://commondatastorage.googleapis.com/chromium-browser-official/"
        + "${name}.tar.bz2";
    sha256 = "067pk6hr7wjx7yxhla5la0rnv51kf7837kfydzydjwapsbcx6m8l";
  };

  patchPhase = ''
    sed -i 's,#!/usr/bin/env python,#!${python}/bin/python,' build/gyp_v8
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

  buildFlags = [
    "LINK=g++"
    "-C out"
    "builddir=$(CURDIR)/Release"
    "BUILDTYPE=Release"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    install -vD out/Release/d8 "$out/bin/d8"
    ${if stdenv.system == "x86_64-darwin" then ''
    install -vD out/Release/lib.target/libv8.dylib "$out/lib/libv8.dylib"
    '' else ''
    install -vD out/Release/lib.target/libv8.so "$out/lib/libv8.so"
    ''}
    cp -vr include "$out/"
  '';

  postFixup = if stdenv.isDarwin then ''
    install_name_tool -change /usr/local/lib/libv8.dylib $out/lib/libv8.dylib -change /usr/lib/libgcc_s.1.dylib ${stdenv.cc.cc}/lib/libgcc_s.1.dylib $out/bin/d8
    install_name_tool -id $out/lib/libv8.dylib -change /usr/lib/libgcc_s.1.dylib ${stdenv.cc.cc}/lib/libgcc_s.1.dylib $out/lib/libv8.dylib
  '' else null;

  meta = with stdenv.lib; {
    description = "Google's open source JavaScript engine";
    platforms = with platforms; linux;
    license = licenses.bsd3;
  };
}
