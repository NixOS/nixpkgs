{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, glib
}:

stdenv.mkDerivation rec {
  pname = "libslirp";
  version = "4.6.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "slirp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1Zp1+PW0WtNzRYIA87X42CJeSzVFhi5sGi9/rlUP4Vo=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ glib ];

  postPatch = ''
    echo ${version} > .tarball-version
  '';

  meta = with lib; {
    description = "General purpose TCP-IP emulator";
    homepage = "https://gitlab.freedesktop.org/slirp/libslirp";
    license = licenses.bsd3;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.unix;
  };
}
