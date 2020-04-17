{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, glib
}:

stdenv.mkDerivation rec {
  pname = "libslirp";
  version = "4.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "slirp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qk513fgfh4hwb1ajjmvg9m1bl97m3n731ymxqsh1c3fj468a2am";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ glib ];

  meta = with stdenv.lib; {
    description = "General purpose TCP-IP emulator";
    homepage = "https://gitlab.freedesktop.org/slirp/libslirp";
    license = licenses.bsd3;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
