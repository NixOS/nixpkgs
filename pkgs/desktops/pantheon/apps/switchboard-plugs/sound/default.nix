{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pantheon
, meson
, ninja
, pkg-config
, vala
, libgee
, granite
, gtk3
, pulseaudio
, libcanberra-gtk3
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sound";
  version = "2.2.7";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0yjqws7ryfid9lcafgzzbfnjjwccsankscwdwqfw486qid85whzc";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/switchboard-plug-sound/pull/203
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-sound/commit/1f3b9f001ace4c457ab194158dff04ba5e25d278.patch";
      sha256 = "1lmf2bbif2wkfv500nxbqxp8jdmnjg8yk8xhx3g2g55d15rc5hk4";
    })
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libcanberra-gtk3
    libgee
    pulseaudio
    switchboard
  ];

  meta = with lib; {
    description = "Switchboard Sound Plug";
    homepage = "https://github.com/elementary/switchboard-plug-sound";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
