{ pkgs, stdenv, lib, fetchurl, makeWrapper
, python27, python27Packages
, dtc, glib, pixman, SDL, xlibs
, nodejs, freetype, zlib }:

let
  requirements = import ./requirements.nix { inherit pkgs; };
  qemu-rpath = lib.makeLibraryPath [ dtc glib pixman SDL xlibs.libX11 zlib stdenv.cc.cc.lib ];
in
stdenv.mkDerivation rec {
  name = "pebble-sdk-${version}";
  version = "4.5";

  src = fetchurl {
    url = "https://s3.amazonaws.com/assets.getpebble.com/pebble-tool/${name}-linux64.tar.bz2";
    sha256 = "15yiypx9rnwyzsn4s4z1wmn1naw6mk7dpsiljmw3078ag66z1ca7";
  };

  buildInputs = [ python27 makeWrapper python27Packages.wrapPython];
  propagatedBuildInputs = [ freetype nodejs zlib ] ++ builtins.attrValues requirements.packages;

  # Pebble needs some extra environment variables, and the compiler needs to be
  # able to able to link against freetype and zlib.
  makeWrapperArgs = [
    "--set PEBBLE_PATH $out/"
    "--set PEBBLE_TOOLCHAIN_PATH $out/arm-cs-tools/bin"
    "--set PHONESIM_PATH ${requirements.packages.pypkjs}/bin/pypkjs"
    "--set LD_LIBRARY_PATH \$LD_LIBRARY_PATH:${freetype}/lib:${zlib}/lib:${stdenv.cc.cc.lib}/lib"
    "--set PYTHONPATH $PYTHONPATH"
  ];

  # The default pebble script does setup that we do via nix, so overwrite it
  # with a link to the nix wrapper.
  installPhase = ''
    mkdir -p $out
    ln -sf $out/pebble-tool/pebble.py bin/pebble
    cp -ax . $out
    wrapPythonProgramsIn $out/pebble-tool
  '';

  # By default, the sdk calls the phone simulator wrapper with python, but nix
  # replaces it with a shell wrapper.  This patch calls the wrapper directly.
  patches = [ ./exec-phonesim.patch ];

  # TODO: There's probably a better way to fix all the binaries...
  postFixup = ''
    for f in $out/arm-cs-tools/{bin,arm-none-eabi/bin,libexec/gcc/arm-none-eabi/4.7.2}/* \
             $out/bin/qemu-pebble; do
      if [[ -f $f && "$f" != *.la && "$f" != *.so && "$f" != *.so.* ]]; then
        patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 $f
      fi
    done
    patchelf --set-rpath ${qemu-rpath} $out/bin/qemu-pebble
  '';

  meta = with stdenv.lib; {
    homepage = https://developer.pebble.com/sdk;
    description = "SDK to build applications for the Pebble smartwatch";

    license = https://developer.pebble.com/legal/sdk-license/;

    # It's supported on other platforms, but I can't easily test them.
    platforms = platforms.linux;

    maintainers = [ maintainers.edanaher ];
  };
}
