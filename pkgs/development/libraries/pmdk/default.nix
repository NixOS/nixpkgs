{ lib, stdenv, fetchFromGitHub
, autoconf, libndctl, pkg-config, gnum4, pandoc
}:

stdenv.mkDerivation rec {
  pname = "pmdk";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner  = "pmem";
    repo   = "pmdk";
    rev    = "refs/tags/${version}";
    sha256 = "0awmkj6j9y2pbqqmp9ql00s7qa3mnpppa82dfy5324lindq0z8a1";
  };

  nativeBuildInputs = [ autoconf pkg-config gnum4 pandoc ];
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
