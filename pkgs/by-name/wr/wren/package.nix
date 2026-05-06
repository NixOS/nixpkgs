{
  lib,
  stdenv,
  fetchFromGitHub,
  fixDarwinDylibNames,
  gnumake,
  nix-update-script,
  python3,
  testers,
}:

let
  makeDir =
    if stdenv.hostPlatform.isDarwin then
      "projects/make.mac"
    else if stdenv.hostPlatform.isBSD then
      "projects/make.bsd"
    else
      "projects/make";

  makeConfig = if stdenv.hostPlatform.is64bit then "release_64bit" else "release_32bit";

  canRunTests = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wren";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "wren-lang";
    repo = "wren";
    rev = finalAttrs.version;
    hash = "sha256-ZaJ9As7xGPB0Ty1kVsTBCweeiIgfROZbtUHxYT0tFnE=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    gnumake
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  nativeCheckInputs = [
    python3
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^([0-9]+\\.[0-9]+\\.[0-9]+)$" ];
  };

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    versionCheck = true;
  };

  postPatch = ''
    # The premake-generated makefiles hardcode `-m64`/`-m32`, which breaks
    # non-x86 platforms (e.g. aarch64) and cross compilation.
    substituteInPlace ${makeDir}/*.make \
      --replace-fail " -m64" "" \
      --replace-fail " -m32" ""

    ${lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      # The makefiles hardcode FHS library search paths.
      substituteInPlace ${makeDir}/*.make \
        --replace-fail "-L/usr/lib64" "" \
        --replace-fail "-L/usr/lib32" ""
    ''}
  '';

  enableParallelBuilding = true;

  makeFlags = [
    "-C"
    makeDir
    "config=${makeConfig}"
  ];

  buildFlags = [
    "wren"
  ]
  ++ lib.optionals canRunTests [ "wren_test" ]
  ++ lib.optional (!stdenv.hostPlatform.isStatic) "wren_shared";

  doCheck = canRunTests;
  checkPhase = ''
    runHook preCheck
    python3 util/test.py
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 src/include/wren.{h,hpp} -t "$dev/include"

    install -Dm644 lib/libwren.a -t "$out/lib"
    ${lib.optionalString (!stdenv.hostPlatform.isStatic) ''
      install -Dm755 lib/libwren${stdenv.hostPlatform.extensions.sharedLibrary} -t "$out/lib"
    ''}

    mkdir -p "$dev/lib/pkgconfig"
    cat > "$dev/lib/pkgconfig/wren.pc" <<EOF
    prefix=$out
    libdir=\''${prefix}/lib
    includedir=$dev/include

    Name: ${finalAttrs.pname}
    Description: ${finalAttrs.meta.description}
    Version: ${finalAttrs.version}
    Libs: -L\''${libdir} -lwren
    Libs.private: -lm
    Cflags: -I\''${includedir}
    EOF

    runHook postInstall
  '';

  meta = {
    description = "Small, fast, class-based concurrent scripting language";
    homepage = "https://wren.io/";
    changelog = "https://github.com/wren-lang/wren/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ Zaczero ];
    pkgConfigModules = [ "wren" ];
    platforms = lib.platforms.unix;
  };
})
