{ stdenv
, lib
, fetchgit
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "tllist";
  version = "1.0.5";

  src = fetchgit {
    url = "https://codeberg.org/dnkl/tllist.git";
    rev = version;
    sha256 = "wJEW7haQBtCR2rffKOFyqH3aq0eBr6H8T6gnBs2bNRg=";
  };

  nativeBuildInputs = [ meson ninja ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/tllist";
    description = "C header file only implementation of a typed linked list";
    longDescription = ''
      Most C implementations of linked list are untyped. That is, their data
      carriers are typically void *. This is error prone since your compiler
      will not be able to help you correct your mistakes (oh, was it a
      pointer-to-a-pointer... I thought it was just a pointer...).

      tllist addresses this by using pre-processor macros to implement dynamic
      types, where the data carrier is typed to whatever you want; both
      primitive data types are supported as well as aggregated ones such as
      structs, enums and unions.
    '';

    license = licenses.mit;
    maintainers = with maintainers; [ fionera AndersonTorres ];
    platforms = platforms.all;
  };
}
