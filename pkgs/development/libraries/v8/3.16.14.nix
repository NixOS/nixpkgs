{ stdenv, fetchurl, gyp, readline, python, which, icu }:

assert readline != null;

let
  arch = if stdenv.is64bit then "x64" else "ia32";
in

stdenv.mkDerivation rec {
  name = "v8-${version}";
  version = "3.16.14";

  src = fetchurl {
    url = "https://commondatastorage.googleapis.com/chromium-browser-official/"
        + "${name}.tar.bz2";
    sha256 = "073f33zcb7205jp9g5ha5d7j2hfa98zs0jql572nb552z0xw3rkz";
  };

  configurePhase = stdenv.lib.optionalString stdenv.isDarwin ''
    ln -s /usr/bin/xcodebuild $TMPDIR
    export PATH=$TMPDIR:$PATH
  '' + ''
    PYTHONPATH="tools/generate_shim_headers:$PYTHONPATH" \
      ${gyp}/bin/gyp \
        -f make \
        --generator-output="out" \
        -Dflock_index=0 \
        -Dv8_enable_i18n_support=1 \
        -Duse_system_icu=1 \
        -Dconsole=readline \
        -Dcomponent=shared_library \
        -Dv8_target_arch=${arch} \
        --depth=. -Ibuild/standalone.gypi \
        build/all.gyp
  '';

  nativeBuildInputs = [ which ];
  buildInputs = [ readline python icu ];

  buildFlags = [
    "-C out"
    "builddir=$(CURDIR)/Release"
    "BUILDTYPE=Release"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    install -vD out/Release/d8 "$out/bin/d8"
    ${if stdenv.system == "x86_64-darwin" then ''
    install -vD out/Release/libv8.dylib "$out/lib/libv8.dylib"
    '' else ''
    install -vD out/Release/libv8.so "$out/lib/libv8.so"
    ''}
    cp -vr include "$out/"
  '';

  postFixup = if stdenv.isDarwin then ''
    install_name_tool -change /usr/local/lib/libv8.dylib $out/lib/libv8.dylib $out/bin/d8
    install_name_tool -id $out/lib/libv8.dylib $out/lib/libv8.dylib
  '' else null;

  meta = with stdenv.lib; {
    description = "V8 is Google's open source JavaScript engine";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd3;
  };
}
