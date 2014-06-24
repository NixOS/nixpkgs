{ stdenv, lib, go, fetchFromGitHub }:

let
  goDeps = [
    {
      root = "github.com/mitchellh/gox";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "gox";
        rev = "c7329055e2aeb253a947e5cc876586ff4ca19199";
        sha256 = "0zhb88jjxqn3sdc4bpzvajqvgi9igp5gk03q12gaksaxhy2wl4jy";
      };
    }
    {
      root = "github.com/mitchellh/iochan";
      src = fetchFromGitHub {
        owner = "mitchellh";
        repo = "iochan";
        rev = "b584a329b193e206025682ae6c10cdbe03b0cd77";
        sha256 = "1fcwdhfci41ibpng2j4c1bqfng578cwzb3c00yw1lnbwwhaq9r6b";
      };
    }
  ];
  sources = stdenv.mkDerivation rec {
    name = "go-deps";
    buildCommand =
      lib.concatStrings
        (map (dep: ''
                mkdir -p $out/src/`dirname ${dep.root}`
                ln -s ${dep.src} $out/src/${dep.root}
              '') goDeps);
  };
in

stdenv.mkDerivation rec {
  name = "gox";

  src = sources;

  propagatedBuildInputs = [ go ];

  installPhase = ''
    ensureDir $out/bin
    export GOPATH=$src
    go build -v -o $out/bin/gox github.com/mitchellh/gox
  '';

  meta = with lib; {
    description = "A simple, no-frills tool for Go cross compilation that behaves a lot like standard go build";
    homepage    = https://github.com/mitchellh/gox;
    maintainers = with maintainers; [ cstrahan ];
    platforms   = platforms.unix;
  };
}
