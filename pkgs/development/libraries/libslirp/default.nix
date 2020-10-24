{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, glib
, fetchpatch
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
    # fix meson.build on darwin
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/slirp/libslirp/-/commit/9f82a47b81f2864422b82c1e40e51a2ed9c6ac32.patch";
      sha256 = "13mfhfi6scchy9l9ri4cvvic1i0jh0mwcv0pkvrf667wzllsjxll";
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
    platforms = platforms.unix;
  };
}
