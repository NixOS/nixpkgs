{ lib, stdenv, fetchFromGitHub
, autoconf, libndctl, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "pmdk";
  version = "1.7";

  src = fetchFromGitHub {
    owner  = "pmem";
    repo   = "pmdk";
    rev    = "refs/tags/${version}";
    sha256 = "1833sq0f1msaqwn31dn1fp37a6d5zp995i9gkazanydmppi2qy0i";
  };

  nativeBuildInputs = [ autoconf pkg-config ];
  buildInputs = [ libndctl ];
  enableParallelBuilding = true;

  outputs = [ "out" "lib" "dev" "man" ];

  patchPhase = "patchShebangs utils";

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
