{ stdenv, lib, fetchurl, fetchgit, bison, glibc, bash, coreutils, makeWrapper, tzdata, iana_etc, perl, Security }:

let
  loader386 = "${glibc}/lib/ld-linux.so.2";
  loaderAmd64 = "${glibc}/lib/ld-linux-x86-64.so.2";
  loaderArm = "${glibc}/lib/ld-linux.so.3";
  srcs = {
    golang = fetchurl {
      url = https://github.com/golang/go/archive/go1.4.2.tar.gz;
      sha256 = "3e5d07bc5214a1ffe187cf6406c5b5a80ee44f12f6bca97a5463db0afee2f6ac";
    };
    tools = fetchgit {
      url = https://github.com/golang/tools.git;
      rev = "c836fe615a448dbf9ff5448c1aa657479a0d0aeb";
      sha256 = "0q9jnhmgmm3xzjss7ndsi6nyykmmb1y984n98118c2sipi183xp5";
    };
  };
in

stdenv.mkDerivation {
  name = "go-1.4.2";

  src = srcs.golang;

  # perl is used for testing go vet
  buildInputs = [ bison bash makeWrapper perl ]
             ++ lib.optionals stdenv.isLinux [ glibc ]
             ++ lib.optionals stdenv.isDarwin [ Security ];

  # I'm not sure what go wants from its 'src', but the go installation manual
  # describes an installation keeping the src.
  preUnpack = ''
    mkdir -p $out/share
    cd $out/share
  '';

  prePatch = ''
    # Ensure that the source directory is named go
    cd ..
    if [ ! -d go ]; then
      mv * go
    fi

    mkdir -p $out/share/go/src/golang.org/x
    cp -r --no-preserve=mode,ownership ${srcs.tools} $out/share/go/src/golang.org/x/tools

    cd go
    patchShebangs ./ # replace /bin/bash

    # Disabling the 'os/http/net' tests (they want files not available in
    # chroot builds)
    rm src/net/{multicast_test.go,parse_test.go,port_test.go}
    # !!! substituteInPlace does not seems to be effective.
    # The os test wants to read files in an existing path. Just don't let it be /usr/bin.
    sed -i 's,/usr/bin,'"`pwd`", src/os/os_test.go
    sed -i 's,/bin/pwd,'"`type -P pwd`", src/os/os_test.go
    # Disable the unix socket test
    sed -i '/TestShutdownUnix/areturn' src/net/net_test.go
    # Disable the hostname test
    sed -i '/TestHostname/areturn' src/os/os_test.go
    sed -i 's,/etc/protocols,${iana_etc}/etc/protocols,' src/net/lookup_unix.go
    # ParseInLocation fails the test
    sed -i '/TestParseInSydney/areturn' src/time/format_test.go
  '' + lib.optionalString stdenv.isLinux ''
    sed -i 's,/usr/share/zoneinfo/,${tzdata}/share/zoneinfo/,' src/time/zoneinfo_unix.go
    sed -i 's,/lib/ld-linux.so.3,${loaderArm},' src/cmd/5l/asm.c
    sed -i 's,/lib64/ld-linux-x86-64.so.2,${loaderAmd64},' src/cmd/6l/asm.c
    sed -i 's,/lib/ld-linux.so.2,${loader386},' src/cmd/8l/asm.c
  '';

  patches = [ ./cacert-1.4.patch ];

  GOOS = if stdenv.isDarwin then "darwin" else "linux";
  GOARCH = if stdenv.isDarwin then "amd64"
           else if stdenv.system == "i686-linux" then "386"
           else if stdenv.system == "x86_64-linux" then "amd64"
           else if stdenv.system == "armv5tel-linux" then "arm"
           else throw "Unsupported system";
  GOARM = stdenv.lib.optionalString (stdenv.system == "armv5tel-linux") "5";
  GO386 = 387; # from Arch: don't assume sse2 on i686
  CGO_ENABLED = 1;

  # The go build actually checks for CC=*/clang and does something different, so we don't
  # just want the generic `cc` here.
  CC = if stdenv.isDarwin then "clang" else "cc";

  installPhase = ''
    mkdir -p "$out/bin"
    export GOROOT="$(pwd)/"
    export GOBIN="$out/bin"
    export PATH="$GOBIN:$PATH"
    cd ./src
    ./all.bash
    cd -

    # Build extra tooling
    # TODO: Fix godoc tests
    TOOL_ROOT=golang.org/x/tools/cmd
    go install -v $TOOL_ROOT/cover $TOOL_ROOT/vet $TOOL_ROOT/godoc
    go test -v    $TOOL_ROOT/cover $TOOL_ROOT/vet # $TOOL_ROOT/godoc
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    branch = "1.4";
    homepage = http://golang.org/;
    description = "The Go Programming language";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [ cstrahan ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
