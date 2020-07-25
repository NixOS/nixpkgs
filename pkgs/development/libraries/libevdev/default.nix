{ stdenv, fetchurl, fetchpatch, python3 }:

stdenv.mkDerivation rec {
  pname = "libevdev";
  version = "1.9.0";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/${pname}-${version}.tar.xz";
    sha256 = "17pb5375njb1r05xmk0r57a2j986ihglh2n5nqcylbag4rj8mqg7";
  };

  patches = [
    # Fix libevdev-python tests on aarch64
    # https://gitlab.freedesktop.org/libevdev/libevdev/merge_requests/63
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/libevdev/libevdev/commit/66113fe84f62bab3a672a336eb10b255d2aa5ce7.patch";
      sha256 = "gZKr/P+/OqU69IGslP8CQlcGuyzA/ulcm+nGwHdis58=";
    })
  ];

  nativeBuildInputs = [ python3 ];

  meta = with stdenv.lib; {
    description = "Wrapper library for evdev devices";
    homepage = "http://www.freedesktop.org/software/libevdev/doc/latest/index.html";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.amorsillo ];
  };
}
