{ stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pantheon
, substituteAll
, meson
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, switchboard
, pciutils
, elementary-feedback
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-about";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-wis6wNEOOjPLUCT9vRRhMxbKHR2Y2nZArKogSF/FQv8=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    switchboard
  ];

  patches = [
    # Get OS Info from GLib.Environment
    # https://github.com/elementary/switchboard-plug-about/pull/128
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-about/commit/5ed29988e3a895b2df66e5529df0f12a94d5517c.patch";
      sha256 = "1ipDxnpDZjpSEzZdtOeNe5U+QOXiB5M+hC3yDAsl/rQ=";
    })

    # Use Pretty Name
    # https://github.com/elementary/switchboard-plug-about/pull/134
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-about/commit/653d131dc8fac10ae7523f2bf6b179ffffa9c0fd.patch";
      sha256 = "AsM49Dc9/yn2tG6fqjfedeOlDXUu+iEoyNUmNYLH+zE=";
    })

    (substituteAll {
      src = ./fix-paths.patch;
      inherit pciutils;
      elementary_feedback = elementary-feedback;
    })
  ];

  meta = with stdenv.lib; {
    description = "Switchboard About Plug";
    homepage = "https://github.com/elementary/switchboard-plug-about";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
