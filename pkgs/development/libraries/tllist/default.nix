{ stdenv, lib, fetchgit, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "tllist";
  version = "1.0.1";

  src = fetchgit {
    url = "https://codeberg.org/dnkl/tllist.git";
    rev = "${version}";
    sha256 = "0xifbbfg1kn281jybdc6ns5kzz0daha4hf47bd0yc0wcmvcfbgmp";
  };

  nativeBuildInputs = [
    meson ninja
  ];

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/tllist";
    description = "C header file only implementation of a typed linked list";
    maintainers = with maintainers; [ fionera ];
    license = licenses.mit;
    platforms = with platforms; linux;
  };
}
