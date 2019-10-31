{ stdenv, fetchFromGitHub, pkgconfig }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "libco-canonical";
  version = "19.1";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "libco";
    rev = "v${version}";
    sha256 = "03a0fq8f8gc4hjzcf0zsjib4mzag47rxrrg9b5r6bx53vj5rhj78";
  };

  nativeBuildInputs = [ pkgconfig ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  outputs = [ "dev" "out" ];

  meta = {
    description = "A cooperative multithreading library written in C89";
    homepage = "https://github.com/canonical/libco";
    license = licenses.isc;
    maintainers = with maintainers; [ wucke13 ];
  };
}
