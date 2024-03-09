{ lib, stdenv, fetchFromGitHub, autoreconfHook, scheme48, fetchpatch }:

stdenv.mkDerivation {
  pname = "scsh";
  version = "0.7pre";

  src = fetchFromGitHub {
    owner = "scheme";
    repo = "scsh";
    rev = "4acf6e4ed7b65b46186ef0c9c2a1e10bef8dc052";
    sha256 = "sha256-92NtMK5nVd6+WtHj/Rk6iQEkGsNEZySTVZkkbqKrLYY=";
    fetchSubmodules = true;
  };

  patches = [
    # Don't not include util.h if libutil.h is available
    # https://github.com/scheme/scsh/pull/49
    (fetchpatch {
      url = "https://github.com/scheme/scsh/commit/b04e902de983761d7f432b2cfa364ca5d162a364.patch";
      hash = "sha256-XSHzzCOBkraqW2re1ePoFl9tKQB81iQ0W9wvv83iGdA=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ scheme48 ];
  configureFlags = [ "--with-scheme48=${scheme48}" ];

  meta = with lib; {
    description = "A Scheme shell";
    homepage = "http://www.scsh.net/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ joachifm ];
    platforms = with platforms; unix;
    mainProgram = "scsh";
  };
}
