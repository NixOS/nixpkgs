{ stdenv
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, pkg-config
, glib
}:

stdenv.mkDerivation rec {
  pname = "libslirp";
  version = "4.3.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "slirp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pzgjj2x2vrjshrzrl2x39xp5lgwg4b4y9vs8xvadh1ycl10v3fv";
  };

  patches = [
    # remove >4.3.1
    (fetchpatch {
      name = "CVE-2020-29129_CVE-2020-29130.patch";
      url = "https://gitlab.freedesktop.org/slirp/libslirp/-/commit/2e1dcbc0c2af64fcb17009eaf2ceedd81be2b27f.patch";
      sha256 = "01vbjqgnc0kp881l5p6b31cyyirhwhavm6x36hlgkymswvl3wh9w";
    })
  ];

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ glib ];

  postPatch = ''
    echo ${version} > .tarball-version
  '';

  meta = with stdenv.lib; {
    description = "General purpose TCP-IP emulator";
    homepage = "https://gitlab.freedesktop.org/slirp/libslirp";
    license = licenses.bsd3;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
