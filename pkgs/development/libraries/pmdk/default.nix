{ stdenv, fetchFromGitHub
, autoconf, libndctl, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "pmdk-${version}";
  version = "1.6";

  src = fetchFromGitHub {
    owner  = "pmem";
    repo   = "pmdk";
    rev    = "refs/tags/${version}";
    sha256 = "11h9h5ifgaa5f6v9y77s5lmsj7k61qg52992s1361cmvl0ndgl9k";
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
