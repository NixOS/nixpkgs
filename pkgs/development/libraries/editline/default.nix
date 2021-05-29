{ lib, stdenv, fetchFromGitHub, autoreconfHook, nix-update-script, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "editline";
  version = "1.17.1";
  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "editline";
    rev = version;
    sha256 = "sha256-0FeDUVCUahbweH24nfaZwa7j7lSfZh1TnQK7KYqO+3g=";
  };

  patches = [
  ];

  nativeBuildInputs = [ autoreconfHook ];

  outputs = [ "out" "dev" "man" "doc" ];

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    homepage = "https://troglobit.com/editline.html";
    description = "A readline() replacement for UNIX without termcap (ncurses)";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ dtzWill oxalica ];
    platforms = platforms.all;
  };
}
