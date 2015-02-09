{ go }:

{ name, buildInputs ? []

# Go import path of the package
, goPackagePath

, meta ? {}, ... } @ args:

go.stdenv.mkDerivation ( args // {
  name = "go${go.meta.branch}-${name}";
  buildInputs = [ go ] ++ buildInputs;

  configurePhase = args.configurePhase or ''
    runHook preConfigure

    cd "$NIX_BUILD_TOP"
    mkdir -p "go/src/$(dirname "$goPackagePath")"
    mv "$sourceRoot" "go/src/$goPackagePath"

    GOPATH=$NIX_BUILD_TOP/go:$GOPATH

    runHook postConfigure
  '';

  buildPhase = args.buildPhase or ''
    runHook preBuild

    if [ -n "$subPackages" ] ; then
	for p in $subPackages ; do
            go install $buildFlags "''${buildFlagsArray[@]}" -p $NIX_BUILD_CORES -v $goPackagePath/$p
	done
    else
	find . -type d | while read d; do
            for i in $d/*.go; do
                go install $buildFlags "''${buildFlagsArray[@]}" -p $NIX_BUILD_CORES -v $d
                break
	    done
	done
    fi

    runHook postBuild
  '';

  checkPhase = args.checkPhase or ''
    runHook preCheck

    if [ -n "$subPackages" ] ; then
	for p in $subPackages ; do
            go test -p $NIX_BUILD_CORES -v $goPackagePath/$p
	done
    else
	find . -type d | while read d; do
            for i in $d/*_test.go; do
                go test -p $NIX_BUILD_CORES -v $d
                break
	    done
	done
    fi

    runHook postCheck
  '';

  installPhase = args.installPhase or ''
    runHook preInstall

    mkdir $out

    if [ -z "$dontInstallSrc" ]; then
        local dir
        for d in pkg src; do
            mkdir -p $out/share/go
            dir="$NIX_BUILD_TOP/go/$d"
            [ -e "$dir" ] && cp -r $dir $out/share/go
        done
    fi

    dir="$NIX_BUILD_TOP/go/bin"
    [ -e "$dir" ] && cp -r $dir $out

    runHook postInstall
  '';

  meta = meta // {
    # add an extra maintainer to every package
    maintainers = (meta.maintainers or []) ++ [ go.stdenv.lib.maintainers.emery ];
  };
})
