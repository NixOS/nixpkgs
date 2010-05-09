args: with args;
stdenv.mkDerivation {
  name = "libixp_for_wmii";
  phases = "unpackPhase installPhase";
  installPhase = "
     export LDFLAGS\=$(echo \$NIX_LDFLAGS | sed -e 's/-rpath/-L/g')
     sed -i -e \"s%^PREFIX.*%PREFIX=\$out%\" \\
            -e \"s%^\\(INCLUDE.*\\)%\\1 \$NIX_CFLAGS_COMPILE%\" \\
            -e \"s%^\\(LIBS.*\\)%\\1 \$LDFLAGS%\" \\
              config.mk
     make
     mkdir -p \$out/include
     cp -r include/*.h \$out/include
     cp -r lib \$out
  ";
  src = fetchurl {
    url = http://dl.suckless.org/libs/libixp-0.5.tar.gz;
    sha256 = "0jqyw8xzih7x7apdp2s9w8agjry890kf55zj2habsg78cyxz1x35";
  };

  meta = {
    homepage = http://libs.suckless.org/libixp;
    description = "stand-alone client/server 9P library";
    license = "MIT / LPL";
  };
}
