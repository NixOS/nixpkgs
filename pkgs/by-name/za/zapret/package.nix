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
  version = "0-unstable-2024-10-12";

  src = fetchFromGitHub {
    owner = "bol-van";
    repo = "zapret";
    rev = "d760093f52c02c05177dc0ba66aa833179a489e5";
    hash = "sha256-cIZsTK1SuI/YfN8oDb/nBmPA5d3QhWzKSEzn5wEcadc=";
  };

  buildInputs = [ libcap zlib libnetfilter_queue libnfnetlink ];
  nativeBuildInputs = [ iptables nftables gawk ];

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin

    make TGT=$out/bin

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/usr/share/zapret/init.d/sysv
    mkdir -p $out/usr/share/docs

    cp $src/blockcheck.sh $out/bin/blockcheck

    substituteInPlace $out/bin/blockcheck \
      --replace-fail '$(cd "$EXEDIR"; pwd)' "$out/usr/share/zapret"

    cp $src/init.d/sysv/functions $out/usr/share/zapret/init.d/sysv/functions
    cp $src/init.d/sysv/zapret $out/usr/share/zapret/init.d/sysv/init.d

    substituteInPlace $out/usr/share/zapret/init.d/sysv/functions \
      --replace-fail "/opt/zapret" "\"$out/usr/share/zapret\""

    touch $out/usr/share/zapret/config

    cp -r $src/docs/* $out/usr/share/docs

    mkdir -p $out/usr/share/zapret/{common,ipset}

    cp $src/common/* $out/usr/share/zapret/common
    cp $src/ipset/* $out/usr/share/zapret/ipset

    rm -f $out/usr/share/zapret/ipset/zapret-hosts-user-exclude.txt.default

    mkdir -p $out/usr/share/zapret/nfq
    ln -s ../../../../bin/nfqws $out/usr/share/zapret/nfq/nfqws

    for i in ip2net mdig tpws
    do
      mkdir -p $out/usr/share/zapret/$i
      ln -s ../../../../bin/$i $out/usr/share/zapret/$i/$i
    done

    ln -s ../usr/share/zapret/init.d/sysv/init.d $out/bin/zapret

    runHook postInstall
  '';

  meta = with lib; {
    description = "DPI bypass multi platform";
    homepage = "https://github.com/bol-van/zapret";
    license = licenses.mit;
    maintainers = with maintainers; [ nishimara ];
    mainProgram = "zapret";

    # probably gonna work on darwin, but untested
    broken = stdenv.hostPlatform.isDarwin;
  };
}
