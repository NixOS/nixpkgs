{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  fixDarwinDylibNames,
  javaBindings ? false,
  ocamlBindings ? false,
  pythonBindings ? true,
  jdk ? null,
  ocaml ? null,
  findlib ? null,
  zarith ? null,
  nix-update-script,
}:

assert javaBindings -> jdk != null;
assert ocamlBindings -> ocaml != null && findlib != null && zarith != null;

stdenv.mkDerivation rec {
  pname = "z3";
  version = "4.13.4";

  src = fetchFromGitHub {
    owner = "Z3Prover";
    repo = "z3";
    rev = "z3-${version}";
    hash = "sha256-8hWXCr6IuNVKkOegEmWooo5jkdmln9nU7wI8T882BSE=";
  };

  strictDeps = true;

  nativeBuildInputs =
    [ python3 ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames
    ++ lib.optional javaBindings jdk
    ++ lib.optionals ocamlBindings [
      ocaml
      findlib
    ];
  propagatedBuildInputs = [ python3.pkgs.setuptools ] ++ lib.optionals ocamlBindings [ zarith ];
  enableParallelBuilding = true;

  postPatch = lib.optionalString ocamlBindings ''
    export OCAMLFIND_DESTDIR=$ocaml/lib/ocaml/${ocaml.version}/site-lib
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
  '';

  configurePhase =
    lib.concatStringsSep " " (
      [ "${python3.pythonOnBuildForHost.interpreter} scripts/mk_make.py --prefix=$out" ]
      ++ lib.optional javaBindings "--java"
      ++ lib.optional ocamlBindings "--ml"
      ++ lib.optional pythonBindings "--python --pypkgdir=$out/${python3.sitePackages}"
    )
    + "\n"
    + "cd build";

  doCheck = true;
  checkPhase = ''
    make -j $NIX_BUILD_CORES test
    ./test-z3 -a
  '';

  postInstall =
    ''
      mkdir -p $dev $lib
      mv $out/lib $lib/lib
      mv $out/include $dev/include
    ''
    + lib.optionalString pythonBindings ''
      mkdir -p $python/lib
      mv $lib/lib/python* $python/lib/
      ln -sf $lib/lib/libz3${stdenv.hostPlatform.extensions.sharedLibrary} $python/${python3.sitePackages}/z3/lib/libz3${stdenv.hostPlatform.extensions.sharedLibrary}
    ''
    + lib.optionalString javaBindings ''
      mkdir -p $java/share/java
      mv com.microsoft.z3.jar $java/share/java
      moveToOutput "lib/libz3java.${stdenv.hostPlatform.extensions.sharedLibrary}" "$java"
    '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/z3 -version 2>&1 | grep -F "Z3 version $version"
  '';

  outputs =
    [
      "out"
      "lib"
      "dev"
      "python"
    ]
    ++ lib.optional javaBindings "java"
    ++ lib.optional ocamlBindings "ocaml";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^z3-(4\.13\.\d+)$"
    ];
  };

  meta = with lib; {
    description = "High-performance theorem prover and SMT solver";
    mainProgram = "z3";
    homepage = "https://github.com/Z3Prover/z3";
    changelog = "https://github.com/Z3Prover/z3/releases/tag/z3-${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      thoughtpolice
      ttuegel
      numinit
    ];
  };
}
