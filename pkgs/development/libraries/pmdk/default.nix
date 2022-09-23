{ lib, stdenv, fetchFromGitHub
, autoconf, libndctl, pkg-config, gnum4, pandoc
}:

stdenv.mkDerivation rec {
  pname = "pmdk";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner  = "pmem";
    repo   = "pmdk";
    rev    = "refs/tags/${version}";
    hash = "sha256-8bnyLtgkKfgIjJkfY/ZS1I9aCYcrz0nrdY7m/TUVWAk=";
  };

  nativeBuildInputs = [ autoconf pkg-config gnum4 pandoc ];
  buildInputs = [ libndctl ];
  enableParallelBuilding = true;

  outputs = [ "out" "lib" "dev" "man" ];

  patchPhase = "patchShebangs utils";

  NIX_CFLAGS_COMPILE = "-Wno-error";

  installPhase = ''
    make install prefix=$out

    mkdir -p $lib $dev $man/share
    mv $out/share/man $man/share/man
    mv $out/include $dev/include
    mv $out/lib     $lib/lib
  '';

  meta = with lib; {
    description = "Persistent Memory Development Kit";
    homepage    = "https://github.com/pmem/pmdk";
    license     = licenses.lgpl21;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = [ "x86_64-linux" ]; # aarch64 is experimental
  };
}
