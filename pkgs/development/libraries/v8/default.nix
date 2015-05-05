{ stdenv, fetchurl, gyp, icu, python, readline, which }:

assert readline != null;

let
  inherit (stdenv) isArm isDarwin isi686 isMips isx86_64 system;
  inherit (stdenv.lib) optionalString;
  # For arches see:
  # https://github.com/v8/v8-git-mirror/blob/master/build/detect_v8_host_arch.py
  arch = (
    if isi686 then "ia32"
    else if isx86_64 then "x64"
    else if isArm then "arm"
    #else if isArm64 then "arm64"
    #else if isMips then "mipsel" # isMips currently mixes both 32 & 64bit mips
    #else if isMips64 then "mips64el"
    #else if isPPC64 then "ppc64" # Nix does not support PPC
    else throw "v8 does not support the `${system}' platform"
  );
in

stdenv.mkDerivation rec {
  name = "v8-${version}";
  version = "3.30.33.16";

  src = fetchurl {
    url = "https://commondatastorage.googleapis.com/chromium-browser-official/${name}.tar.bz2";
    sha256 = "1azf1b36gqj4z5x0k9wq2dkp99zfyhwb0d6i2cl5fjm3k6js7l45";
  };

  patchPhase = ''
    patchShebangs ./build/gyp_v8
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

  nativeBuildInputs = [ python which ];
  buildInputs = [ icu readline ];

  buildFlags = [
    "LINK=g++"
    "-C out"
    "builddir=$(CURDIR)/Release"
    "BUILDTYPE=Release"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    install -vD out/Release/d8 "$out/bin/d8"
    cp -vr include "$out/"
  '' + (if isDarwin then ''
      install -vD out/Release/lib.target/libv8.dylib "$out/lib/libv8.dylib"
    '' else ''
      install -vD out/Release/lib.target/libv8.so "$out/lib/libv8.so"
    ''
  );

  postFixup = optionalString isDarwin ''
    install_name_tool -change /usr/local/lib/libv8.dylib $out/lib/libv8.dylib -change /usr/lib/libgcc_s.1.dylib ${stdenv.cc.cc}/lib/libgcc_s.1.dylib $out/bin/d8
    install_name_tool -id $out/lib/libv8.dylib -change /usr/lib/libgcc_s.1.dylib ${stdenv.cc.cc}/lib/libgcc_s.1.dylib $out/lib/libv8.dylib
  '';

  meta = with stdenv.lib; {
    description = "Google's open source JavaScript engine";
    homepage = https://developers.google.com/v8/;
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd3;
  };
}
