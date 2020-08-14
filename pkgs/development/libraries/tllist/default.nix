{ stdenv, lib, fetchgit, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "tllist";
  version = "1.0.2";

  src = fetchgit {
    url = "https://codeberg.org/dnkl/tllist.git";
    rev = "${version}";
    sha256 = "095wly66z9n2r6h318rackgl4g1w9l1vj96367ngcw7rpva9yppl";
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
