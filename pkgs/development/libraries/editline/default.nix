{ stdenv, fetchFromGitHub, autoreconfHook, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "editline";
  version = "1.17.0";
  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "editline";
    rev = version;
    sha256 = "0vjm42y6zjmi6hdcng0l7wkksw7s50agbmk5dxsc3292q8mvq8v6";
  };

  patches = [
    (fetchpatch {
      name = "fix-for-multiline-as-one-line.patch";
      url = "https://github.com/troglobit/editline/commit/ceee039cfc819c8e09eebbfca192091b0cf8df75.patch";
      sha256 = "149fmfva05ghzwkd0bq1sahdbkys3qyyky28ssqb5jq7q9hw3ddm";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  outputs = [ "out" "dev" "man" "doc" ];

  meta = with stdenv.lib; {
    homepage = http://troglobit.com/editline.html;
    description = "A readline() replacement for UNIX without termcap (ncurses)";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
