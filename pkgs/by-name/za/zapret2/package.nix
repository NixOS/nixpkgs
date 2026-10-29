{
  stdenv,
  fetchFromGitHub,
  lib,
  makeWrapper,
  pkg-config,
  curl,
  netcat,
  gawk,
  gnugrep,
  luajit,
  ipset,
  libcap,
  libmnl,
  libnfnetlink,
  libnetfilter_queue,
  systemdLibs,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zapret2";
  version = "0.9.5.2";

  outputs = [
    "out"
    "doc"
  ];

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bol-van";
    repo = "zapret2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U2Sfm+51QwlBWZGCDwClVeXJrwssoA6tchc/FP+kyF8=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short=12 HEAD > COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    luajit
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
    libmnl
    libnfnetlink
    libnetfilter_queue
    ipset
    systemdLibs
  ];

  postPatch = ''
    substituteInPlace "init.d/systemd/nfqws2@.service" \
      --replace-fail "ExecSearchPath=/opt/zapret2/nfq2" "ExecSearchPath=$out/bin"
  '';

  preBuild = ''
    makeFlagsArray+=("CFLAGS=-DZAPRET_GH_VER=${finalAttrs.src.tag} -DZAPRET_GH_HASH=`cat $src/COMMIT`")
  '';

  makeFlags = [
    (if stdenv.hostPlatform.isLinux then "systemd" else "bsd")
    "TGT=${placeholder "out"}/bin"
  ];

  env = {
    ZAPRET_BASE = "${placeholder "out"}/share/zapret2";
    ZAPRET_RW = "/etc/zapret2";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$ZAPRET_BASE"
    for spec in "blockcheck2.sh" "blockcheck2.d" "common" "ipset" "lua"; do
      cp -R "$spec" "$ZAPRET_BASE/"
    done

    pushd docs
    mkdir -p "$doc/share/doc/zapret2"
    cp *.md changes*.txt "$doc/share/doc/zapret2"
    popd

    wrapProgram "$ZAPRET_BASE/blockcheck2.sh" \
      --set ZAPRET_BASE "$ZAPRET_BASE" \
      --set ZAPRET_RW "$ZAPRET_RW" \
      --set NFQWS2 "$out/bin/nfqws2" \
      --set DVTWS2 "$out/bin/dvtws2" \
      --set MDIG "$out/bin/mdig" \
      --prefix "PATH" : "${
        lib.makeBinPath [
          curl
          netcat
          # don't wrap with iptables/nftables so that it uses the one from the
          # system path (depending on the networking firewall backend)
        ]
      }"

    for file in "$ZAPRET_BASE/ipset"/*.sh; do
      if [ -x "$file" ]; then
        wrapProgram "$file" \
          --set ZAPRET_BASE "$ZAPRET_BASE" \
          --set ZAPRET_RW "$ZAPRET_RW" \
          --prefix "PATH" : "${
            lib.makeBinPath [
              gawk
              gnugrep
            ]
          }"
      fi
    done

    ln -s "$ZAPRET_BASE/blockcheck2.sh" "$out/bin/blockcheck2"

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 "init.d/systemd/nfqws2@.service" -t "$out/lib/systemd/system"
    ''}

    runHook postInstall
  '';

  meta = {
    description = "Anti-DPI software for bypassing DPI systems";
    homepage = "https://github.com/bol-van/zapret2";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    # Darwin lacks ipdivert in kernel (making dvtws2 unusable) and zapret2
    # doesn't include tpws
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [ andre4ik3 ];
    mainProgram = if stdenv.hostPlatform.isLinux then "nfqws2" else "dvtws2";
  };
})
