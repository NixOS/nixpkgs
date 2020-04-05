{ python
, runCommand
, substituteAll
, lib
, callPackage
}:

let
  envs = let
    inherit python;
    pythonEnv = python.withPackages(ps: with ps; [ ]);
  in {
    # Plain Python interpreter
    plain = rec {
      env = python;
      interpreter = env.interpreter;
      is_venv = "False";
      is_nixenv = "False";
    };
  } // lib.optionalAttrs (python.implementation != "graal") {
    # Python Nix environment (python.buildEnv)
    nixenv = rec {
      env = pythonEnv;
      interpreter = env.interpreter;
      is_venv = "False";
      is_nixenv = "True";
    };
  } // lib.optionalAttrs (python.isPy3k && (!python.isPyPy)) rec {
    # Venv built using plain Python
    # Python 2 does not support venv
    # TODO: PyPy executable name is incorrect, it should be pypy-c or pypy-3c instead of pypy and pypy3.
    plain-venv = rec {
      env = runCommand "${python.name}-venv" {} ''
        ${python.interpreter} -m venv $out
      '';
      interpreter = "${env}/bin/${python.executable}";
      is_venv = "True";
      is_nixenv = "False";
    };

    # Venv built using Python Nix environment (python.buildEnv)
    # TODO: Cannot create venv from a  nix env
    # Error: Command '['/nix/store/ddc8nqx73pda86ibvhzdmvdsqmwnbjf7-python3-3.7.6-venv/bin/python3.7', '-Im', 'ensurepip', '--upgrade', '--default-pip']' returned non-zero exit status 1.
    # nixenv-venv = rec {
    #   env = runCommand "${python.name}-venv" {} ''
    #     ${pythonEnv.interpreter} -m venv $out
    #   '';
    #   interpreter = "${env}/bin/${pythonEnv.executable}";
    #   is_venv = "True";
    #   is_nixenv = "True";
    # };
  };

  # All PyPy package builds are broken at the moment
  integrationTests = lib.optionalAttrs (python.isPy3k  && (!python.isPyPy)) rec {
    # Before the addition of NIX_PYTHONPREFIX mypy was broken with typed packages
    nix-pythonprefix-mypy = callPackage ./tests/test_nix_pythonprefix {
      interpreter = python;
    };
  };

  testfun = name: attrs: runCommand "${python.name}-tests-${name}" ({
    inherit (python) pythonVersion;
  } // attrs) ''
    cp -r ${./tests} tests
    chmod -R +w tests
    substituteAllInPlace tests/test_python.py
    ${attrs.interpreter} -m unittest discover --verbose tests #/test_python.py
    mkdir $out
    touch $out/success
  '';

in lib.mapAttrs testfun envs // integrationTests
