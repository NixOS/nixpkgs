{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, alsaSupport ? !stdenv.isDarwin, alsa-lib
, dbusSupport ? !stdenv.isDarwin, dbus
, pipewireSupport ? !stdenv.isDarwin, pipewire
, pulseSupport ? !stdenv.isDarwin, libpulseaudio
, CoreServices, AudioUnit, AudioToolbox
}:

stdenv.mkDerivation rec {
  pname = "openal-soft";
  version = "1.22.2";

  src = fetchFromGitHub {
    owner = "kcat";
    repo = "openal-soft";
    rev = version;
    sha256 = "sha256-MVM0qCZDWcO7/Hnco+0dBqzBLcWD279xjx0slxxlc4w=";
  };

  # this will make it find its own data files (e.g. HRTF profiles)
  # without any other configuration
  patches = [ ./search-out.patch ];
  postPatch = ''
    substituteInPlace core/helpers.cpp \
      --replace "@OUT@" $out
  '';

  strictDeps = true;

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = lib.optional alsaSupport alsa-lib
    ++ lib.optional dbusSupport dbus
    ++ lib.optional pipewireSupport pipewire
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optionals stdenv.isDarwin [ CoreServices AudioUnit AudioToolbox ];

  cmakeFlags = [
    # Automatically links dependencies without having to rely on dlopen, thus
    # removes the need for NIX_LDFLAGS.
    "-DALSOFT_DLOPEN=OFF"
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    # https://github.com/NixOS/nixpkgs/issues/183774
    "-DOSS_INCLUDE_DIR=${stdenv.cc.libc}/include"
  ];

  meta = with lib; {
    description = "OpenAL alternative";
    homepage = "https://kcat.strangesoft.net/openal.html";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ftrvxmtrx];
    platforms = platforms.unix;
  };
}
