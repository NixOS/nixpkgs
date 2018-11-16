{ stdenv, lib, fetchurl, gyp, readline, python, which, icu, utillinux, cctools }:

assert readline != null;

let
  arch = if stdenv.isAarch32
    then (if stdenv.is64bit then "arm64" else "arm")
    else (if stdenv.is64bit then "x64" else "ia32");
  armHardFloat = stdenv.isAarch32 && (stdenv.hostPlatform.platform.gcc.float or null) == "hard";
in

stdenv.mkDerivation rec {
  name = "v8-${version}";
  version = "3.16.14.11";

  src = fetchurl {
    url = "https://commondatastorage.googleapis.com/chromium-browser-official/"
        + "${name}.tar.bz2";
    sha256 = "1gpf2xvhxfs5ll3m2jlslsx9jfjbmrbz55iq362plflrvf8mbxhj";
  };

  postPatch = ''
    sed -i 's/-Werror//' build/standalone.gypi build/common.gypi
  '';

  configurePhase = stdenv.lib.optionalString stdenv.isDarwin ''
    export GYP_DEFINES="mac_deployment_target=$MACOSX_DEPLOYMENT_TARGET"
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
        ${lib.optionalString armHardFloat "-Dv8_use_arm_eabi_hardfloat=true"} \
        --depth=. -Ibuild/standalone.gypi \
        build/all.gyp
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's@/usr/bin/env python@${python}/bin/python@g' out/gyp-mac-tool
  '';

  nativeBuildInputs = [ which ];
  buildInputs = [ readline python icu ]
                  ++ lib.optional stdenv.isLinux utillinux
                  ++ lib.optional stdenv.isDarwin cctools;

  NIX_CFLAGS_COMPILE = "-Wno-error -w";

  buildFlags = [
    "-C out"
    "builddir=$(CURDIR)/Release"
    "BUILDTYPE=Release"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    install -vD out/Release/d8 "$out/bin/d8"
    ${if stdenv.isDarwin then ''
    install -vD out/Release/libv8.dylib "$out/lib/libv8.dylib"
    '' else ''
    install -vD out/Release/lib.target/libv8.so "$out/lib/libv8.so"
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
