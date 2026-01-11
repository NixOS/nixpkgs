{
  stdenv,
  fetchFromGitHub,
  lib,
  makeWrapper,
  pkg-config,
  bind,
  curl,
  iptables,
  libcap,
  libmnl,
  libnfnetlink,
  libnetfilter_queue,
  luajit,
  nmap,
  ipset,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zapret2";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "bol-van";
    repo = "zapret2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0mVdqKRTWZcDEQUrAjqK1ujtUAeuqOYtM1pyo+yJxN8=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    bind
    curl
    iptables
    libcap
    libmnl
    libnfnetlink
    libnetfilter_queue
    luajit
    nmap
    ipset
  ];

  # Fix Lua detection and systemd unit
  postPatch = ''
    # Fix deprecated KillMode
    sed -i 's/KillMode=none/KillMode=mixed/g' init.d/systemd/zapret2.service

    # Prepare user exclude files
    cp ipset/zapret-hosts-user-exclude.txt.default ipset/zapret-hosts-user-exclude.txt

    # Help Makefile find luajit
    sed -i 's|lua5.1|luajit-5.1|g' nfq2/Makefile || true
    sed -i 's|LUA_PC_NAME := lua|LUA_PC_NAME := luajit|g' nfq2/Makefile || true
  '';

  # Set environment variables for the build
  preBuild = ''
    export LUA_INCLUDE_DIR=${luajit}/include/luajit-2.1
    export LUA_LIB_DIR=${luajit}/lib
    export PKG_CONFIG_PATH="${luajit}/lib/pkgconfig:$PKG_CONFIG_PATH"
  '';

  # Pass variables to make
  makeFlags = [
    "PREFIX=${placeholder "out"}/opt/zapret2"
    "LUA_LIB_NAME=luajit-5.1"
  ];

  installPhase = ''
    mkdir -p $out/opt/zapret2/{ip2net,mdig,nfq2,ipset,blockcheck2.d/{custom,standard},files/fake,common,lua,init.d/sysv}
    mkdir -p $out/etc/{systemd/system,sysusers.d}
    mkdir -p $out/share/{doc/zapret2,licenses/zapret2}
    mkdir -p $out/bin

    # Install binaries (built from source)
    install -Dm755 nfq2/nfqws2  -t $out/opt/zapret2/nfq2/
    install -Dm755 ip2net/ip2net -t $out/opt/zapret2/ip2net/
    install -Dm755 mdig/mdig    -t $out/opt/zapret2/mdig/

    # Install scripts and configs
    install -Dm755 blockcheck2.sh -t $out/opt/zapret2/
    install -Dm644 blockcheck2.d/custom/* -t $out/opt/zapret2/blockcheck2.d/custom/
    install -Dm644 blockcheck2.d/standard/* -t $out/opt/zapret2/blockcheck2.d/standard/
    install -Dm644 files/fake/* -t $out/opt/zapret2/files/fake/
    install -Dm644 common/* -t $out/opt/zapret2/common/
    install -Dm644 lua/* -t $out/opt/zapret2/lua/

    # Install ipset files
    for f in ipset/*.sh; do [ -f "$f" ] && install -Dm755 "$f" -t $out/opt/zapret2/ipset/; done
    for f in ipset/*.txt ipset/*.default; do [ -f "$f" ] && install -Dm644 "$f" -t $out/opt/zapret2/ipset/; done

    # Install init scripts
    install -Dm755 init.d/sysv/{functions,zapret2} -t $out/opt/zapret2/init.d/sysv/
    install -Dm644 init.d/systemd/* -t $out/etc/systemd/system/

    # Create sysusers config
    echo "u zapret2 - \"zapret2 Anti-DPI software\"" > $out/etc/sysusers.d/zapret2.conf

    # Create symlinks
    ln -s $out/opt/zapret2/init.d/sysv/zapret2 $out/bin/zapret2
    ln -s $out/opt/zapret2/ip2net/ip2net $out/bin/ip2net
    ln -s $out/opt/zapret2/mdig/mdig    $out/bin/mdig
    ln -s $out/opt/zapret2/nfq2/nfqws2  $out/bin/nfqws2

    # Install docs
    install -Dm644 docs/*.* -t $out/share/doc/zapret2/
    install -Dm644 docs/LICENSE.txt -T $out/share/licenses/zapret2/LICENSE

    # Install main config
    install -Dm644 config.default -T $out/opt/zapret2/config
  '';

  postFixup = ''
    wrapProgram $out/bin/ip2net --prefix PATH : ${lib.makeBinPath [ bind ]}
    wrapProgram $out/bin/mdig    --prefix PATH : ${
      lib.makeBinPath [
        bind
        nmap
      ]
    }
    wrapProgram $out/bin/nfqws2  --prefix PATH : ${
      lib.makeBinPath [
        iptables
        ipset
        nmap
        curl
        luajit
      ]
    }
  '';

  meta = with lib; {
    description = "Anti-DPI software for bypassing DPI systems";
    homepage = "https://github.com/bol-van/zapret2";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "nfqws2";
  };
})
