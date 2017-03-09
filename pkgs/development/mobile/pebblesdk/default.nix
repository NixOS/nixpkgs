{ pkgs, stdenv, lib, fetchurl, makeWrapper
, python27, python27Packages
, dtc, glib, pixman, SDL, xlibs
, nodejs, freetype, zlib }:

let
  qemu-rpath = lib.makeLibraryPath [ dtc glib pixman SDL xlibs.libX11 zlib stdenv.cc.cc.lib ];
  pebble-rpath = lib.makeLibraryPath [ freetype zlib stdenv.cc.cc.lib ];
  pebble-libs = import ./pebble-libs.nix { inherit pkgs python27Packages; };
in
stdenv.mkDerivation rec {
  name = "pebble-sdk-${version}";
  version = "4.5";

  src = fetchurl {
    url = "https://s3.amazonaws.com/assets.getpebble.com/pebble-tool/${name}-linux64.tar.bz2";
    sha256 = "15yiypx9rnwyzsn4s4z1wmn1naw6mk7dpsiljmw3078ag66z1ca7";
  };

  pythonEnv = (python27.withPackages (ps: with ps; builtins.attrValues pebble-libs ++
    [ colorama httplib2 oauth2client packaging progressbar2 pyasn1 pygeoip
      pyparsing pyqrcode requests2 websocket_client wrapPython ]));

  buildInputs = [ makeWrapper pythonEnv ];
  # Pebble needs some extra environment variables, and the compiler needs to be
  # able to able to link against freetype and zlib.
  propagatedBuildInputs = [ freetype nodejs zlib ];


  # The default pebble script does setup that we do via nix, so overwrite it
  # with a link to the nix wrapper.
  installPhase = ''
    mkdir -p $out
    ln -sf $out/pebble-tool/pebble.py bin/pebble
    cp -ax . $out
  '';

  # By default, the sdk calls the phone simulator wrapper with python, but nix
  # replaces it with a shell wrapper.  This patch calls the wrapper directly.
  patches = [ ./exec-phonesim.patch ];

  # We don't actually need the precise versions specified.
  postPatch = ''
    substituteInPlace requirements.txt --replace "==" ">="
  '';

  # TODO: There's probably a way to automate this a bit more, but this works.
  postFixup = ''
    for f in $out/arm-cs-tools/{bin,arm-none-eabi/bin,libexec/gcc/arm-none-eabi/4.7.2}/* \
             $out/bin/qemu-pebble; do
      if [[ -f $f && "$f" != *.la && "$f" != *.so && "$f" != *.so.* ]]; then
        patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 \
                 --set-rpath ${pebble-rpath} \
                 $f
      fi
    done
    patchelf --set-rpath ${qemu-rpath} $out/bin/qemu-pebble
    wrapProgram $out/bin/pebble \
     --prefix LD_LIBRARY_PATH : "${pebble-rpath}" \
     --set PEBBLE_PATH $out/ \
     --set PEBBLE_TOOLCHAIN_PATH $out/arm-cs-tools/bin \
     --set PHONESIM_PATH ${pebble-libs.pypkjs}/bin/pypkjs
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
