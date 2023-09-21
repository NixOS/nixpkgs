{ lib, stdenv, fetchurl, cmake, pkg-config, zlib, libpng, libjpeg, giflib, libtiff
}:

stdenv.mkDerivation rec {
  pname = "pslib";
  version = "0.4.6";

  src = fetchurl {
    name = "${pname}-snixource-${version}.tar.gz";
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0m191ckqj1kj2yvxiilqw26x4vrn7pnlc2vy636yphjxr02q8bk4";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ zlib libpng libjpeg giflib libtiff ];

  doCheck = true;

  outputs = [ "out" "dev" "doc" ];

  installPhase = ''
    mkdir -p $out/lib
    for path in *.so *.so.* *.o *.o.*; do
      mv $path $out/lib/
    done
    mkdir -p $dev/include
    mv ../include/libps $dev/include
    if test -d nix-support; then
      mv nix-support $dev
    fi
    mkdir -p $doc/share/doc/${pname}
    cp -r ../doc/. $doc/share/doc/${pname}
  '';

  meta = with lib; {
    description = "A C-library for generating multi page PostScript documents";
    homepage = "https://pslib.sourceforge.net/";
    changelog =
      "https://sourceforge.net/p/pslib/git/ci/master/tree/pslib/ChangeLog";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
