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
  version = "72.13";

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
    hash = "sha256-jwhGhxqIhJfkmjT3Zzsy4injQWqSVRet8fZr9VA04sQ=";
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

    # keep $out/usr for backwards compability
    mkdir -p $out/share $out/usr
    ln -s ../share $out/usr/share

    mkdir -p $out/share/zapret/init.d/sysv
    mkdir -p $out/share/docs

    cp $src/blockcheck.sh $out/bin/blockcheck

    substituteInPlace $out/bin/blockcheck \
      --replace-fail '$(cd "$EXEDIR"; pwd)' "$out/share/zapret"

    ln -s ../../bin/blockcheck $out/share/zapret/blockcheck

    cp $src/init.d/sysv/functions $out/share/zapret/init.d/sysv/functions
    cp $src/init.d/sysv/zapret $out/share/zapret/init.d/sysv/init.d

    substituteInPlace $out/share/zapret/init.d/sysv/functions \
      --replace-fail "/opt/zapret" "\"$out/share/zapret\""

    touch $out/share/zapret/config

    cp -r $src/docs/* $out/share/docs

    mkdir -p $out/share/zapret/{common,files/fake,ipset}

    cp $src/common/* $out/share/zapret/common
    cp $src/files/fake/* $out/share/zapret/files/fake
    cp $src/ipset/* $out/share/zapret/ipset

    rm -f $out/share/zapret/ipset/zapret-hosts-user-exclude.txt.default

    mkdir -p $out/share/zapret/nfq
    ln -s ../../../bin/nfqws $out/share/zapret/nfq/nfqws

    for i in ip2net mdig tpws
    do
      mkdir -p $out/share/zapret/$i
      ln -s ../../../bin/$i $out/share/zapret/$i/$i
    done

    ln -s ../share/zapret/init.d/sysv/init.d $out/bin/zapret

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
