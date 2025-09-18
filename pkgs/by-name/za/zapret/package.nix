{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,

  libcap,
  zlib,
  libnetfilter_queue,
  libnfnetlink,
  libmnl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zapret";
  version = "71.4";

  src = fetchFromGitHub {
    owner = "bol-van";
    repo = "zapret";

    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';

    tag = "v${finalAttrs.version}";
    hash = "sha256-n7UasKtoQ4zfy2ho2vOREb0RPrDnhjYYbXcXTjelDvg=";
  };

  buildInputs = [
    libcap
    zlib
    libnetfilter_queue
    libnfnetlink
    libmnl
  ];

  preBuild = ''
    makeFlagsArray+=("CFLAGS=-DZAPRET_GH_VER=${finalAttrs.src.tag} -DZAPRET_GH_HASH=`cat $src/COMMIT`")
  '';

  makeFlags = [ "TGT=${placeholder "out"}/bin" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/usr/share/zapret/init.d/sysv
    mkdir -p $out/usr/share/docs

    cp $src/blockcheck.sh $out/bin/blockcheck

    substituteInPlace $out/bin/blockcheck \
      --replace-fail '$(cd "$EXEDIR"; pwd)' "$out/usr/share/zapret"

    ln -s ../../../bin/blockcheck $out/usr/share/zapret/blockcheck

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "DPI bypass multi platform";
    homepage = "https://github.com/bol-van/zapret";
    changelog = "https://github.com/bol-van/zapret/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nishimara ];
    mainProgram = "zapret";
    platforms = lib.platforms.linux;
  };
})
