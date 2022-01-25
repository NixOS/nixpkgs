{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, pkg-config
, gettext
, itstool
, libxml2
, glib
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "shared-mime-info-unstable";
  version = "2021-12-03";

  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = "shared-mime-info";
    rev = "5a406b06792e26a83c7346b3c2443c0bd8d4cdb2";
    sha256 = "1v7dx7mr0m4lcff1aasg9gxn280zn0ffn6fjg9xc44pnllg01n6s";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    libxml2
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) shared-mime-info;

  buildInputs = [
    libxml2
    glib
  ];

  strictDeps = true;

  mesonFlags = [
    "-Dupdate-mimedb=true"
  ];

  meta = with lib; {
    description = "A database of common MIME types";
    homepage = "http://freedesktop.org/wiki/Software/shared-mime-info";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.freedesktop.members ++ [ maintainers.mimame ];
  };
}
