{ stdenv, fetchFromGitHub
, autoconf, libndctl, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "pmdk";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner  = "pmem";
    repo   = "pmdk";
    rev    = "refs/tags/${version}";
    sha256 = "0iphvm9x8ly8srn3rn50qjp7339x5gpixn77n022xxr79g8jbxy6";
  };

  nativeBuildInputs = [ autoconf pkgconfig ];
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

  meta = with stdenv.lib; {
    description = "Persistent Memory Development Kit";
    homepage    = https://github.com/pmem/pmdk;
    license     = licenses.lgpl21;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = [ "x86_64-linux" ]; # aarch64 is experimental
  };
}
