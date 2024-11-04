{ lib, tracee, makeWrapper }:
tracee.overrideAttrs (oa: {
  pname = oa.pname + "-integration";
  postPatch = oa.postPatch or "" + ''
    # fix the test to look at nixos paths for running programs
      # --replace-fail '"integration.tes"' '"tracee-integrat"' \
    substituteInPlace tests/integration/event_filters_test.go \
      --replace-fail "exec=/usr/bin/dockerd" "comm=dockerd" \
      --replace-fail "exec=/usr/bin" "exec=/tmp/testdir" \
      --replace-fail "/usr/bin/tee" "tee" \
      --replace-fail "/usr/bin" "/run/current-system/sw/bin" \
      --replace-fail 'syscallerAbsPath := filepath.Join("..", "..", "dist", "syscaller")' "syscallerAbsPath := filepath.Join(\"$out/bin/syscaller\")"
    substituteInPlace tests/integration/exec_test.go \
      --replace-fail "/usr/bin" "/run/current-system/sw/bin"
  '';
  nativeBuildInputs = oa.nativeBuildInputs or [ ] ++ [ makeWrapper ];
  buildPhase = ''
    runHook preBuild
    # copy existing built object to dist
    mkdir -p dist/btfhub
    touch dist/btfhub/.placeholder
    cp ${lib.getOutput "lib" tracee}/lib/tracee/tracee.bpf.o ./dist/

    # then compile the tests to be ran later
    mkdir -p $GOPATH/tracee-integration
    CGO_LDFLAGS="$(pkg-config --libs libbpf)" go build -o $GOPATH/tracee-integration/syscaller ./tests/integration/syscaller/cmd
    CGO_LDFLAGS="$(pkg-config --libs libbpf)" go test -tags core,ebpf,integration -c -o $GOPATH/tracee-integration/ ./tests/integration/...
    runHook postBuild
  '';
  doCheck = false;
  installPhase = ''
    mkdir -p $out/bin
    mv $GOPATH/tracee-integration/{integration.test,syscaller} $out/bin/
    # cp -r ${tracee}/bin/signatures $out/bin/
  '';
  doInstallCheck = false;

  outputs = [ "out" ];
  meta = oa.meta // {
    outputsToInstall = [ "out" ];
  };
})
