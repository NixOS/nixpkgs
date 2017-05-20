# /nix/store/151ypclwwxg67zq7in39476agy6njmrb-simavr-1.3/bin/simavr
# 

{ stdenv, fetchFromGitHub, avrgcclibc, libelf, which, git, pkgconfig }:

stdenv.mkDerivation rec {
  name = "simavr-${version}";
  version = "1.3";
  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "buserror";
    repo = "simavr";
    rev = "51d5fa69f9bc3d62941827faec02f8fbc7e187ab";
    sha256 = "0k8xwzw9i6xsmf98q43fxhphq0wvflvmzqma1n4jd1ym9wi48lfx";
  };

  buildFlags = "AVR_ROOT=${avrgcclibc}/avr SIMAVR_VERSION=${version}";
  installFlags = buildFlags + " DESTDIR=$(out)";

  postFixup = stdenv.lib.optional (!stdenv.isDarwin) ''
    target="$out/bin/simavr"
    patchelf --set-rpath "$(patchelf --print-rpath "$target"):$out/lib" "$target"
  '';

  buildInputs = [ which git avrgcclibc libelf pkgconfig  ];

  preBuild = ''
  pwd
  rm -r tests/*
  echo "all: ;" > tests/Makefile
  rm -r examples/*
  echo "all: ;" > examples/Makefile
''  ;


  meta = with stdenv.lib; {
    description = "A lean and mean Atmel AVR simulator for Linux";
    homepage    = https://github.com/buserror/simavr;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ goodrone ];
  };

}
