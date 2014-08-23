{ stdenv, fetchurl, bison, bash, makeWrapper }:

stdenv.mkDerivation {
  name = "go-1.1.2";

  src = fetchurl {
    url = http://go.googlecode.com/files/go1.1.2.src.tar.gz;
    sha256 = "0w7bchhb4b053az3wjp6z342rs9lp9nxf4w2mnfd1b89d6sb7izz";
  };

  buildInputs = [ bison bash makeWrapper ];

  preUnpack = ''
    mkdir -p $out/share
    cd $out/share
  '';

  prePatch = ''
    cd ..
    if [ ! -d go ]; then
      mv * go
    fi
    cd go

    patchShebangs ./ # replace /bin/bash
    rm src/pkg/net/{multicast_test.go,parse_test.go,port_test.go}
    # The os test wants to read files in an existing path. Just it don't be /usr/bin.
    sed -i 's,/usr/bin,'"`pwd`", src/pkg/os/os_test.go
    sed -i 's,/bin/pwd,'"`type -P pwd`", src/pkg/os/os_test.go
    # Disable some tests
    sed -i '/TestHostname/areturn' src/pkg/os/os_test.go
    sed -i '/TestShutdownUnix/areturn' src/pkg/net/net_test.go

  '';

  # Unfortunately we have to use Mac OS X's own GCC
  preBuild = ''
    export PATH=/usr/bin:$PATH
  '';

  #patches = [ ./cacert.patch ];

  GOOS = "darwin";
  GOARCH = if stdenv.system == "x86_64-darwin" then "amd64" else "386";

  installPhase = ''
    mkdir -p "$out/bin"

    # CGO is broken on Maverick. See: http://code.google.com/p/go/issues/detail?id=5926
    # Reevaluate once go 1.1.3 is out
    export CGO_ENABLED=0

    export GOROOT="$(pwd)/"
    export GOBIN="$out/bin"
    export PATH="$GOBIN:$PATH"
    cd ./src
    ./all.bash
    cd -

    # Wrap the tools to define the location of the
    # libraries.
    for a in go gofmt godoc; do
	    wrapProgram "$out/bin/$a" \
	      --set "GOROOT" $out/share/go
    done

    # Copy the emacs configuration for Go files.
    mkdir -p "$out/share/emacs/site-lisp"
    cp ./misc/emacs/* $out/share/emacs/site-lisp/
  '';

  meta = {
    homepage = http://golang.org/;
    description = "The Go Programming language";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [ zef ];
    platforms = stdenv.lib.platforms.darwin;
  };
}
