{ stdenv
, lib
, fetchurl
, meson
, ninja

, pipewire
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "lv2";
  version = "1.18.10";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://lv2plug.in/spec/${pname}-${version}.tar.xz";
    hash = "sha256-eMUbzyG1Tli7Yymsy7Ta4Dsu15tSD5oB5zS9neUwlT8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [ ];

  mesonFlags = [
    # install validators to $dev
    "--bindir=${placeholder "dev"}/bin"

    # These are just example plugins. They pull in outdated gtk-2
    # dependency and many other things. Upstream would like to
    # eventually move them of the project:
    #   https://gitlab.com/lv2/lv2/-/issues/57#note_1096060029
    "-Dplugins=disabled"
    # Pulls in spell checkers among other things.
    "-Dtests=disabled"
    # Avoid heavyweight python dependencies.
    "-Ddocs=disabled"
  ] ++ lib.optionals stdenv.isDarwin [
    "-Dlv2dir=${placeholder "out"}/lib/lv2"
  ];

  passthru = {
    tests = {
      inherit pipewire;
    };
    updateScript = gitUpdater {
      # No nicer place to find latest release.
      url = "https://gitlab.com/lv2/lv2.git";
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    homepage = "https://lv2plug.in";
    description = "A plugin standard for audio systems";
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.unix;
  };
}
