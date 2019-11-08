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

  patchPhase = ''
    # upstream project assumes all build products will go into single directory
    # `$prefix` but we need `includedir` to point to "dev", not "out"
    #
    # pkgs/build-support/setup-hooks/multiple-outputs.sh would normally patch
    # this automatically, but it fails here due to use of absolute paths

    substituteInPlace Makefile \
      --replace "@includedir@|\$(PREFIX)" "@includedir@|${placeholder "dev"}"
  '';

  meta = {
    description = "A cooperative multithreading library written in C89";
    homepage = "https://github.com/canonical/libco";
    license = licenses.isc;
    maintainers = with maintainers; [ wucke13 ];
  };
}
