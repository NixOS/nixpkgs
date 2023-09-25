{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, pkg-config
, alsa-lib
, boost
, decorator
, glib
, just
, libjack2
, scdoc

, withOptionalDependencies ? false

# optional-dependencies
, pyliblo
, tkinter
, dbus-python
, pyinotify
, pysmf
, pyxdg
}:

buildPythonPackage rec {
  version = "unstable-2023-02-03";
  pname = "mididings";

  src = fetchFromGitHub {
    owner = "mididings";
    repo = "mididings";
    rev = "199931b64740cc5f7bc69633349ac3c0e463eca2";
    hash = "sha256-dbFuUWeyOm1vJWeB6We8B+AQU7CLK+Rfo+EKdr1AtNU=";
  };

  postPatch = with lib.versions; ''
    substituteInPlace setup.py \
      --replace boost_python "boost_python${major python.version}${minor python.version}"
    substituteInPlace justfile \
      --replace '/usr/bin/env bash' "$SHELL"
  '';

  preBuild = ''
    just build-manpages
  '';

  nativeBuildInputs = [
    just
    pkg-config
    scdoc
  ];
  buildInputs = [
    glib
    alsa-lib
    libjack2
    boost
  ];
  propagatedBuildInputs = [
    decorator
  ] ++ lib.optionals withOptionalDependencies (
    lib.flatten (lib.attrValues passthru.optional-dependencies)
  );

  passthru.optional-dependencies = {
    livedings = [
      pyliblo
      tkinter
    ];
    mididings-extra = [
      dbus-python
      pyinotify
    ];
    smf = [
      pysmf
    ];
    xdg = [
      pyxdg
    ];
  };

  nativeCheckInputs = lib.flatten (lib.attrValues passthru.optional-dependencies);

  meta = with lib; {
    description = "A MIDI router and processor based on Python, supporting ALSA and JACK MIDI";
    homepage = "https://github.com/mididings/mididings";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ris ];
    platforms = platforms.linux;
  };
}
