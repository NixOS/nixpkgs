{ stdenv, lib, fetchurl, fetchpatch, tzdata, iana-etc, libcCross
, pkg-config
, pcre
, Security }:

let
  libc = if stdenv ? cross then libcCross else stdenv.cc.libc;
in

stdenv.mkDerivation rec {
  pname = "go";
  version = "1.4-bootstrap-${builtins.substring 0 7 revision}";
  revision = "bdd4b9503e47c2c38a9d0a9bb2f5d95ec5ff8ef6";

  src = fetchurl {
    url = "https://github.com/golang/go/archive/${revision}.tar.gz";
    sha256 = "1zdyf883awaqdzm4r3fs76nbpiqx3iswl2p4qxclw2sl5vvynas5";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pcre ];
  depsTargetTargetPropagated = lib.optional stdenv.isDarwin Security;

  hardeningDisable = [ "all" ];

  # The tests try to do stuff with 127.0.0.1 and localhost
  __darwinAllowLocalNetworking = true;

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

    cd go
    patchShebangs ./ # replace /bin/bash

    sed -i 's,/etc/protocols,${iana-etc}/etc/protocols,' src/net/lookup_unix.go
  '' + lib.optionalString stdenv.isLinux ''
    # prepend the nix path to the zoneinfo files but also leave the original value for static binaries
    # that run outside a nix server
    sed -i 's,\"/usr/share/zoneinfo/,"${tzdata}/share/zoneinfo/\"\,\n\t&,' src/time/zoneinfo_unix.go

    # Find the loader dynamically
    LOADER="$(find ${lib.getLib libc}/lib -name ld-linux\* | head -n 1)"

    # Replace references to the loader
    find src/cmd -name asm.c -exec sed -i "s,/lib/ld-linux.*\.so\.[0-9],$LOADER," {} \;
  '';

  patches = [
    ./remove-tools-1.4.patch
  ];

  GOOS = if stdenv.isDarwin then "darwin" else "linux";
  GOARCH = if stdenv.isDarwin then "amd64"
           else if stdenv.hostPlatform.system == "i686-linux" then "386"
           else if stdenv.hostPlatform.system == "x86_64-linux" then "amd64"
           else if stdenv.isAarch32 then "arm"
           else throw "Unsupported system";
  GOARM = lib.optionalString (stdenv.hostPlatform.system == "armv5tel-linux") "5";
  GO386 = 387; # from Arch: don't assume sse2 on i686
  CGO_ENABLED = 0;

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
  '';

  meta = with lib; {
    homepage = "http://golang.org/";
    description = "The Go Programming language";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
