{
  stdenv,
  runCommand,
  lib,
  pname,
  idris2,
  idris2Packages,
  zsh,
  tree,
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
    runCommand "${pname}-${testName}"
      {
        meta.timeout = 60;

        # with idris2 compiled binaries assume zsh is available on darwin, but that
        # is not the case with pure nix environments. Thus, we need to include zsh
        # when we build for darwin in tests. While this is impure, this is also what
        # we find in real darwin hosts.
        nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ zsh ];
      }
      ''
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

  testBuildIdris =
    {
      testName,
      buildIdrisArgs,
      makeExecutable,
      expectedTree,
    }:
    let
      final = pkg: if makeExecutable then pkg.executable else pkg.library { };
      idrisPkg = final (idris2Packages.buildIdris buildIdrisArgs);
    in
    runCommand "${pname}-${testName}"
      {
        meta.timeout = 60;

        nativeBuildInputs = [ tree ];
      }
      ''
        GOT="$(tree ${idrisPkg} | tail -n +2)"

        if [ "$GOT" = '${expectedTree}' ]; then
          echo "${testName} SUCCESS"
        else
          >&2 echo "Got:
          $GOT"
          >&2 echo 'want:
          ${expectedTree}'
          exit 1
        fi

        touch $out
      '';
in
{
  # Simple hello world compiles, runs and outputs as expected
  helloWorld = testCompileAndRun {
    testName = "hello-world";
    code = ''
      module Main

      main : IO ()
      main = putStrLn "Hello World!"
    '';
    want = "Hello World!";
  };

  # Data.Vect.Sort is available via --package contrib
  useContrib = testCompileAndRun {
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

  buildLibrary = testBuildIdris {
    testName = "library-package";
    buildIdrisArgs = {
      ipkgName = "pkg";
      idrisLibraries = [ idris2Packages.idris2Api ];
      src = runCommand "library-package-src" { } ''
        mkdir $out

        cat > $out/Main.idr <<EOF
        module Main

        import Compiler.ANF -- from Idris2Api

        hello : String
        hello = "world"
        EOF

        cat > $out/pkg.ipkg <<EOF
        package pkg
        modules = Main
        depends = idris2
        EOF
      '';
    };
    makeExecutable = false;
    expectedTree = ''
      `-- lib
          `-- idris2-0.7.0
              `-- pkg-0
                  |-- 2023090800
                  |   |-- Main.ttc
                  |   `-- Main.ttm
                  `-- pkg.ipkg

      5 directories, 3 files'';
  };

  buildExecutable = testBuildIdris {
    testName = "executable-package";
    buildIdrisArgs = {
      ipkgName = "pkg";
      idrisLibraries = [ ];
      src = runCommand "executable-package-src" { } ''
        mkdir $out

        cat > $out/Main.idr <<EOF
        module Main

        main : IO ()
        main = putStrLn "hi"
        EOF

        cat > $out/pkg.ipkg <<EOF
        package pkg
        modules = Main
        main = Main
        executable = mypkg
        EOF
      '';
    };
    makeExecutable = true;
    expectedTree = ''
      `-- bin
          `-- mypkg

      2 directories, 1 file'';
  };
}
