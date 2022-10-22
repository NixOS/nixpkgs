{ lib, stdenv, fetchzip, coreutils, perl, gnutar, gzip }:
let
  version = "6M62";
in stdenv.mkDerivation {
  pname = "inform7";
  inherit version;
  buildInputs = [ perl coreutils gnutar gzip ];
  src = fetchzip {
    url = "http://inform7.com/download/content/6M62/I7_6M62_Linux_all.tar.gz";
    sha256 = "0bk0pfymvsn1g8ci0pfdw7dgrlzb232a8pc67y2xk6zgpf3m41vj";
  };
  preConfigure = "touch Makefile.PL";
  buildPhase = "";
  installPhase = ''
    mkdir -p $out
    pushd $src
    ./install-inform7.sh --prefix $out
    popd

    substituteInPlace "$out/bin/i7" \
      --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A design system for interactive fiction";
    homepage = "http://inform7.com/";
    license = licenses.artistic2;
    maintainers = with maintainers; [ mbbx6spp ];
    platforms = platforms.unix;
  };
}
