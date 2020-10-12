{ stdenv, lib, fetchgit, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "tllist";
  version = "1.0.4";

  src = fetchgit {
    url = "https://codeberg.org/dnkl/tllist.git";
    rev = version;
    sha256 = "sha256-+u8p/VmI61SGRhZHaJBwgcVNetNOrYzg2NVQehbfRqg=";
  };

  nativeBuildInputs = [
    meson ninja
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/tllist";
    description = "C header file only implementation of a typed linked list";
    maintainers = with maintainers; [ fionera ];
    license = licenses.mit;
    platforms = with platforms; linux;
  };
}
