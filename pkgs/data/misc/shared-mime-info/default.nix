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
  pname = "shared-mime-info";
  version = "2.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = pname;
    rev = version;
    sha256 = "07bxv44p43pqq4ymfnyy50yli7lwdqymhvclna42rkn1cazq3vb5";
  };

  patches = [
    # xmlto is only used for building the docs, which are not installed anyways.
    (fetchpatch {
      name = "xmlto-optional.patch";
      url = "https://gitlab.freedesktop.org/xdg/shared-mime-info/-/merge_requests/110.patch";
      sha256 = "0p5gxlcmn8ji5bc7pd105s1halqwa1d28lfx9yj43rn6mav7allx";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
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
