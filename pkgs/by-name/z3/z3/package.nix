{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  fixDarwinDylibNames,
  nix-update-script,
  versionCheckHook,

  javaBindings ? false,
  ocamlBindings ? false,
  pythonBindings ? true,
  jdk ? null,
  ocaml ? null,
  findlib ? null,
  zarith ? null,
  ...
}:

assert javaBindings -> jdk != null;
assert ocamlBindings -> ocaml != null && findlib != null && zarith != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "z3";
  version = "4.15.0";

  src = fetchFromGitHub {
    owner = "Z3Prover";
    repo = "z3";
    rev = "z3-${finalAttrs.version}";
    hash = "sha256-fk3NyV6vIDXivhiNOW2Y0i5c+kzc7oBqaeBWj/JjpTM=";
  };

  strictDeps = true;

  nativeBuildInputs =
    [ python3 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ]
    ++ lib.optionals javaBindings [ jdk ]
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

  configurePhase = ''
    runHook preConfigure

    ${python3.pythonOnBuildForHost.interpreter} \
      scripts/mk_make.py \
      --prefix=$out \
      ${lib.optionalString javaBindings "--java"} \
      ${lib.optionalString ocamlBindings "--ml"} \
      ${lib.optionalString pythonBindings "--python --pypkgdir=$out/${python3.sitePackages}"}

    cd build

    runHook postConfigure
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    make -j $NIX_BUILD_CORES test
    ./test-z3 -a

    runHook postCheck
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
  nativeInstallCheckInputs = [ versionCheckHook ];

  outputs =
    [
      "out"
      "lib"
      "dev"
      "python"
    ]
    ++ lib.optionals javaBindings [ "java" ]
    ++ lib.optionals ocamlBindings [ "ocaml" ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^z3-([0-9]+\\.[0-9]+\\.[0-9]+)$"
      ];
    };
  };

  meta = {
    description = "High-performance theorem prover and SMT solver";
    mainProgram = "z3";
    homepage = "https://github.com/Z3Prover/z3";
    changelog = "https://github.com/Z3Prover/z3/releases/tag/z3-${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
      ttuegel
      numinit
    ];
  };
})
