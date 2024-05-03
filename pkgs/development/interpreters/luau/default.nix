{ lib, stdenv, fetchFromGitHub, cmake, gitUpdater, llvmPackages }:

stdenv.mkDerivation rec {
  pname = "luau";
  version = "0.621";

  src = fetchFromGitHub {
    owner = "luau-lang";
    repo = "luau";
    rev = version;
    hash = "sha256-bkuYYGYcnMwQDK81ZH+74hA4XaQfVFMWvAKpy+ODCak=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.libunwind ];

  patches = [
    ./add-pkgconfig.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir -pv "$out/bin" "$dev/lib/pkgconfig" "$dev/include/Luau"

    local execs=(
      luau
      luau-analyze
      luau-ast
      luau-bytecode
      luau-compile
      luau-reduce
    )
    for exec in "''${execs[@]}"; do
      install -Dm755 -t "$out/bin" "$exec"
    done

    local libs=(
      libLuau.Analysis.a
      libLuau.Ast.a
      libLuau.CodeGen.a
      libLuau.Compiler.a
      libLuau.Config.a
      libLuau.VM.a
      libisocline.a
    )
    for lib in "''${libs[@]}"; do
      install -Dm644 -t "$dev/lib" "$lib"
    done

    local headers=(
      $TEMPDIR/source/Analysis/include/Luau/*.h
      $TEMPDIR/source/Ast/include/Luau/*.h
      $TEMPDIR/source/CodeGen/include/*.h
      $TEMPDIR/source/CodeGen/include/Luau/*.h
      $TEMPDIR/source/Common/include/Luau/*.h
      $TEMPDIR/source/Compiler/include/*.h
      $TEMPDIR/source/Compiler/include/Luau/*.h
      $TEMPDIR/source/Config/include/Luau/*.h
      $TEMPDIR/source/VM/include/*.h
      $TEMPDIR/source/extern/isocline/include/*.h
    )

    for header in "''${headers[@]}"; do
      install -Dm644 -t "$dev/include/Luau" "$header"
    done

    cp -v "$TEMPDIR/source/Luau.pc" "Luau.pc"
    substituteInPlace Luau.pc --replace-fail "@out@" "$dev"
    substituteInPlace Luau.pc --replace-fail "@version@" "${version}"
    install -Dm644 -t "$dev/lib/pkgconfig" Luau.pc

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ./Luau.UnitTest
    ./Luau.Conformance

    runHook postCheck
  '';

  passthru.updateScript = gitUpdater { };
  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "A fast, small, safe, gradually typed embeddable scripting language derived from Lua";
    homepage = "https://luau-lang.org/";
    changelog = "https://github.com/luau-lang/luau/releases/tag/${version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ ];
    mainProgram = "luau";
    pkgConfigModules = [ "Luau" ];
  };
}
