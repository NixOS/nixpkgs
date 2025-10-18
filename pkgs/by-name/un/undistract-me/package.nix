{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchpatch,
  coreutils,
  gnused,
  libnotify,
  pulseaudio,
  sound-theme-freedesktop,
  xprop,
}:

stdenvNoCC.mkDerivation {
  pname = "undistract-me";
  version = "0-unstable-2020-08-09";

  src = fetchFromGitHub {
    owner = "jml";
    repo = "undistract-me";
    rev = "2f8ac25c6ad8efcf160d2b480825b1cbb6772aab";
    hash = "sha256-Qw7Cu9q0ZgK/RTvyDdHM5N3eBaKjtYqYH0J+hKMUZX8=";
  };

  patches = [
    # Don't block the terminal when notification sound is played
    #
    # See https://github.com/jml/undistract-me/pull/69
    (fetchpatch {
      url = "https://github.com/jml/undistract-me/commit/2356ebbe8bf2bcb4b95af1ae2bcdc786ce7cc6e8.patch";
      hash = "sha256-Ij3OXTOnIQsYhKVmqjChhN1q4ASZ7waOkfQTTp5XfPo=";
    })

    # Fix showing notifications when using Wayland apps with XWayland
    # running, or connection to X server fails.
    #
    # NOTE: Without a real X server, notifications will not be
    # suppressed when the window running the command is focused.
    #
    # See https://github.com/jml/undistract-me/pull/71
    (fetchpatch {
      url = "https://github.com/jml/undistract-me/commit/3f4ceaf5a4eba8e3cb02236c48247f87e3d1124f.patch";
      hash = "sha256-9AK9Jp3TXJ75Y+jwZXlwQ6j54FW1rOBddoktrm0VX68=";
    })
  ];

  strictDeps = true;

  # Patch in dependencies. Can't use makeWrapper because the bash
  # functions will be sourced and invoked in a different environment
  # for each command invocation.
  postPatch = ''
    for script in *.bash *.sh; do
      substituteInPlace "$script" \
        --replace /usr/share/undistract-me "$out/share/undistract-me" \
        --replace basename ${coreutils}/bin/basename \
        --replace 'cut ' '${coreutils}/bin/cut ' \
        --replace date ${coreutils}/bin/date \
        --replace dirname ${coreutils}/bin/dirname \
        --replace sed ${gnused}/bin/sed \
        --replace notify-send ${libnotify}/bin/notify-send \
        --replace paplay ${pulseaudio}/bin/paplay \
        --replace /usr/share/sounds/freedesktop ${sound-theme-freedesktop}/share/sounds/freedesktop \
        --replace xprop ${xprop}/bin/xprop
    done
  '';

  installPhase = ''
    mkdir -p "$out/share/undistract-me" "$out/etc/profile.d" "$out/share/licenses/undistract-me"
    cp long-running.bash "$out/share/undistract-me"
    cp preexec.bash "$out/share/undistract-me"
    cp undistract-me.sh "$out/etc/profile.d"
    cp LICENSE "$out/share/licenses/undistract-me"
  '';

  meta = with lib; {
    description = "Notifies you when long-running terminal commands complete";
    homepage = "https://github.com/jml/undistract-me";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
