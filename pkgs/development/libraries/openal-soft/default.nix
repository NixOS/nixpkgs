{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, removeReferencesTo
, alsaSupport ? !stdenv.hostPlatform.isDarwin, alsa-lib
, dbusSupport ? !stdenv.hostPlatform.isDarwin, dbus
, pipewireSupport ? !stdenv.hostPlatform.isDarwin, pipewire
, pulseSupport ? !stdenv.hostPlatform.isDarwin, libpulseaudio
, CoreServices, AudioUnit, AudioToolbox
}:

stdenv.mkDerivation rec {
  pname = "openal-soft";
  version = "1.23.1";

  src = fetchFromGitHub {
    owner = "kcat";
    repo = "openal-soft";
    rev = version;
    sha256 = "sha256-jwY1NzNJdWIvVv7TvJyg4cIGFLWGZhL3BkMI1NbOEG0=";
  };

  patches = [
    # this will make it find its own data files (e.g. HRTF profiles)
    # without any other configuration
    ./search-out.patch
  ];
  postPatch = ''
    substituteInPlace core/helpers.cpp \
      --replace "@OUT@" $out
  '';

  strictDeps = true;

  nativeBuildInputs = [ cmake pkg-config removeReferencesTo ];

  buildInputs = lib.optional alsaSupport alsa-lib
    ++ lib.optional dbusSupport dbus
    ++ lib.optional pipewireSupport pipewire
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices AudioUnit AudioToolbox ];

  cmakeFlags = [
    # Automatically links dependencies without having to rely on dlopen, thus
    # removes the need for NIX_LDFLAGS.
    "-DALSOFT_DLOPEN=OFF"
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    # https://github.com/NixOS/nixpkgs/issues/183774
    "-DOSS_INCLUDE_DIR=${stdenv.cc.libc}/include"
  ];

  postInstall = lib.optional pipewireSupport ''
    remove-references-to -t ${pipewire.dev} $(readlink -f $out/lib/*.so)
  '';

  meta = with lib; {
    description = "OpenAL alternative";
    homepage = "https://openal-soft.org/";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ftrvxmtrx];
    platforms = platforms.unix;
  };
}
