{ lib
, stdenv
, autoreconfHook
, pkg-config
, glibc
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "librsyscall";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "catern";
    repo = "rsyscall";
    rev = "v${version}";
    sha256 = "1a89gg6aysyymn1wvaxrgf93334cz1y1zarr5nhxg0vjly8v91pg";
  };
  sourceRoot = "source/c";

  # librsyscall builds some static bootstrap binaries;
  # both static and dynamic libraries will be installed, which is fine.
  dontDisableStatic = true;

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ glibc glibc.static ];

  meta = with lib; {
    description = "Make syscalls remotely";
    homepage = "https://github.com/catern/rsyscall";
    platforms = ["x86_64-linux"];
    license = licenses.mit;
    maintainers = with maintainers; [ catern ];
  };
}
