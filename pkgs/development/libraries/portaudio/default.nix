{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  libjack2,
  pkg-config,
  which,
}:

stdenv.mkDerivation rec {
  pname = "portaudio";
  version = "190700_20210406";

  src = fetchurl {
    url = "https://files.portaudio.com/archives/pa_stable_v${version}.tgz";
    sha256 = "1vrdrd42jsnffh6rq8ap2c6fr4g9fcld89z649fs06bwqx1bzvs7";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    which
  ];
  buildInputs = [
    libjack2
  ] ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform alsa-lib) [ alsa-lib ];

  configureFlags = [
    "--disable-mac-universal"
    "--enable-cxx"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=nullability-inferred-on-nested-type -Wno-error=nullability-completeness-on-arrays -Wno-error=implicit-const-int-float-conversion";

  # Disable parallel build as it fails as:
  #   make: *** No rule to make target '../../../lib/libportaudio.la',
  #     needed by 'libportaudiocpp.la'.  Stop.
  # Next release should address it with
  #     https://github.com/PortAudio/portaudio/commit/28d2781d9216115543aa3f0a0ffb7b4ee0fac551.patch
  enableParallelBuilding = false;

  postPatch = ''
    # workaround for the configure script which expects an absolute path
    export AR=$(which $AR)
  '';

  # not sure why, but all the headers seem to be installed by the make install
  installPhase =
    ''
      make install
    ''
    + lib.optionalString (lib.meta.availableOn stdenv.hostPlatform alsa-lib) ''
      # fixup .pc file to find alsa library
      sed -i "s|-lasound|-L${alsa-lib.out}/lib -lasound|" "$out/lib/pkgconfig/"*.pc
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      cp include/pa_mac_core.h $out/include/pa_mac_core.h
    '';

  meta = with lib; {
    description = "Portable cross-platform Audio API";
    homepage = "https://www.portaudio.com/";
    # Not exactly a bsd license, but alike
    license = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.unix;
  };

  passthru = {
    api_version = 19;
  };
}
