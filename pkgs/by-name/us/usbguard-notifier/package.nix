{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libqb,
  usbguard,
  librsvg,
  libnotify,
  catch2,
  asciidoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "usbguard-notifier";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Cropi";
    repo = "usbguard-notifier";
    tag = "usbguard-notifier-${finalAttrs.version}";
    hash = "sha256-EP+NUzT5nu7rJeSEyxs/JARVx7jH2Vip73ksmQw+ABM=";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail 'AC_MSG_FAILURE([Cannot detect the systemd system unit dir])' \
        'systemd_unit_dir="$out/lib/systemd/user"'
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    asciidoc
  ];

  buildInputs = [
    libqb
    usbguard
    librsvg
    libnotify
  ];

  configureFlags = [ "CPPFLAGS=-I${catch2}/include/catch2" ];

  meta = {
    description = "Notifications for detecting usbguard policy and device presence changes";
    homepage = "https://github.com/Cropi/usbguard-notifier";
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    mainProgram = "usbguard-notifier";
  };
})
