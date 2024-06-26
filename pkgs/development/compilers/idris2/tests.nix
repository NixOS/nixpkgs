{
  stdenv,
  lib,
  pname,
  idris2,
  zsh,
}:

let
  testCompileAndRun =
    {
      testName,
      code,
      want,
      packages ? [ ],
    }:
    let
      packageString = builtins.concatStringsSep " " (map (p: "--package " + p) packages);
    in
    stdenv.mkDerivation {
      name = "${pname}-${testName}";
      meta.timeout = 60;

      # with idris2 compiled binaries assume zsh is available on darwin, but that
      # is not the case with pure nix environments. Thus, we need to include zsh
      # when we build for darwin in tests. While this is impure, this is also what
      # we find in real darwin hosts.
      nativeBuildInputs = lib.optionals stdenv.isDarwin [ zsh ];

      buildCommand = ''
        set -eo pipefail

        cat > packageTest.idr <<HERE
        ${code}
        HERE

        ${idris2}/bin/idris2 ${packageString} -o packageTest packageTest.idr

        GOT=$(./build/exec/packageTest)

        if [ "$GOT" = "${want}" ]; then
          echo "${testName} SUCCESS: '$GOT' = '${want}'"
        else
          >&2 echo "Got '$GOT', want: '${want}'"
          exit 1
        fi

        touch $out
      '';
    };
in
{
  # Simple hello world compiles, runs and outputs as expected
  hello-world = testCompileAndRun {
    testName = "hello-world";
    code = ''
      module Main

      main : IO ()
      main = putStrLn "Hello World!"
    '';
    want = "Hello World!";
  };

  # Data.Vect.Sort is available via --package contrib
  use-contrib = testCompileAndRun {
    testName = "use-contrib";
    packages = [ "contrib" ];
    code = ''
      module Main

      import Data.Vect
      import Data.Vect.Sort  -- from contrib

      vect : Vect 3 Int
      vect = 3 :: 1 :: 5 :: Nil

      main : IO ()
      main = putStrLn $ show (sort vect)
    '';
    want = "[1, 3, 5]";
  };
}
