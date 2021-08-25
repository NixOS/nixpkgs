{ stdenv, lib, fetchFromGitHub, bootstrapped ? true, ripgrep }:

let
  libBQN = fetchFromGitHub {
    owner = "mlochbaum";
    repo = "bqn";
    rev = "e46d1edb07cea7f9a5be26165213db8a17b4fa4f";
    sha256 = "13kbak06ivw935jfdc98k8bxy0qkpdj2xwp1ajqbkckbr02pqz40";
  };

  bytecode = fetchFromGitHub {
    owner = "dzaima";
    repo = "cbqn";
    rev = "6aa6834666e91f2490a86efd249ba9c7b1d35794";
    sha256 = "046k0gkwc5mw4wm551hsgiqcvmh0a7j43pr55l8sh6faliqgrnhi";
  };

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "cbqn";
    rev = "a7ee8044d165119c6df8e93c5c13286bac54bf59";
    sha256 = "1zqfa8pzqhgg1n7xs46fjqhqh3njsyrk9b8lbzcl6ka4rrjkx4j5";
  };

  generic = { useBytecode ? false, bqn ? null, fullTestSuite ? true }:
    # Either use bytecode, or have bqn specified.
    assert (bqn != null) == !useBytecode;

    stdenv.mkDerivation rec {
      pname = "cbqn" + lib.optionalString useBytecode "-bytecode";
      version = "unstable-2021-08-24";

      inherit src;
      patches = lib.optional useBytecode ./generated.patch;
      nativeBuildInputs = [ bqn ];
      checkInputs = lib.optional fullTestSuite ripgrep;

      buildPhase = (if useBytecode then ''
        echo "Copying bytecode from bootstrap"
        cp ${bytecode}/src/gen/* src/gen/
      '' else ''
        echo "Generating bytecode..."
        bqn ./genRuntime ${libBQN}
      '') + ''
        sed -i 's|/usr/bin/env bash|${stdenv.shell}|' makefile
        make
      '';

      installPhase = ''
        mkdir -p $out/bin
        cp BQN $out/bin
        ln -s $out/bin/BQN $out/bin/bqn
      '';

      doCheck = true;
      checkPhase = ''
        # Implement a very rudimentary smoke test
        echo "↕4" | ./BQN | grep "0 1 2 3"
      '' + lib.optionalString fullTestSuite ''
        ./BQN ${libBQN}/test/this.bqn | rg --passthru "All passed!"
      '';

      meta = with lib; {
        description = "An APL-like programming language";
        maintainers = with maintainers; [ synthetica ];
        platforms = with platforms; all;
        license = licenses.isc;
        homepage = "https://mlochbaum.github.io/BQN/";
      };
    };

  phase1 = generic { useBytecode = true; fullTestSuite = false; };
  phase2 = generic { bqn = phase1; };
  phase3 = generic { bqn = phase2; };
in
  if bootstrapped then phase3 else phase1
