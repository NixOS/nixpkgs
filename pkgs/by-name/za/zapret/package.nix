{
  lib,
  stdenv,
  fetchFromGitHub,

  libcap,
  zlib,
  libnetfilter_queue,
  libnfnetlink,

  iptables,
  nftables,
  gawk
}:

stdenv.mkDerivation {
  pname = "zapret";
  version = "0-unstable-2024-08-01";

  src = fetchFromGitHub {
    owner = "bol-van";
    repo = "zapret";
    rev = "9cf72b7c68f6a7c80dfddc6c1cf6d6db32718376";
    sha256 = "sha256-8cqKCNYLLkZXlwrybKUPG6fLd7gmf8zV9tjWoTxAwIY=";
  };

  buildInputs = [ libcap zlib libnetfilter_queue libnfnetlink ];
  nativeBuildInputs = [ iptables nftables gawk ];

  buildPhase = ''
    mkdir -p $out/bin

    make TGT=$out/bin
  '';

  installPhase = ''
    mkdir -p $out/usr/share/zapret/init.d/sysv
    mkdir -p $out/usr/share/docs

    cp $src/blockcheck.sh $out/bin/blockcheck

    substituteInPlace $out/bin/blockcheck \
      --replace "ZAPRET_BASE=\"\$EXEDIR\"" "ZAPRET_BASE=$out/usr/share/zapret"

    cp $src/init.d/sysv/functions $out/usr/share/zapret/init.d/sysv/functions
    cp $src/init.d/sysv/zapret $out/usr/share/zapret/init.d/sysv/init.d

    substituteInPlace $out/usr/share/zapret/init.d/sysv/functions \
      --replace "ZAPRET_BASE=\$(readlink -f \"\$EXEDIR/../..\")" "ZAPRET_BASE=$out/usr/share/zapret"

    touch $out/usr/share/zapret/config

    cp -r $src/docs/* $out/usr/share/docs

    mkdir -p $out/usr/share/zapret/{common,ipset}

    cp $src/common/* $out/usr/share/zapret/common
    cp $src/ipset/* $out/usr/share/zapret/ipset

    mkdir -p $out/usr/share/zapret/nfq
    ln -s ../../../../bin/nfqws $out/usr/share/zapret/nfq/nfqws

    for i in ip2net mdig tpws
    do
      mkdir -p $out/usr/share/zapret/$i
      ln -s ../../../../bin/$i $out/usr/share/zapret/$i/$i
    done

    ln -s ../usr/share/zapret/init.d/sysv/init.d $out/bin/zapret
  '';

  meta = with lib; {
    description = "DPI bypass multi platform";
    homepage = "https://github.com/bol-van/zapret";
    license = licenses.mit;
    maintainers = with maintainers; [ nishimara ];
    mainProgram = "zapret";

    # probably gonna work on darwin, but untested
    broken = stdenv.isDarwin;
  };
}
