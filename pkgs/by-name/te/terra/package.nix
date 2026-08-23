{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  llvmPackages_22,
  ncurses,
  cmake,
  libxml2,
  symlinkJoin,
  cudaPackages,
  enableCUDA ? config.cudaSupport,
  libffi,
  libpfm,
  versionCheckHook,
}:

let
  # grep LUAJIT_COMMIT in cmake/Modules/GetLuaJIT.cmake
  luajitRev = "14d8a7a27dc8c626ab9e7c7e9e50b6df6def4f03";
  luajitBase = "LuaJIT-${luajitRev}";
  luajitArchive = "${luajitBase}.tar.gz";
  luajitSrc = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = luajitRev;
    hash = "sha256-c2f9wCiDyC+G16ryLNcBp8nm+rLNXAsgafJgXHaQUTk=";
  };

  llvmPackages = llvmPackages_22;
  llvmMerged = symlinkJoin {
    name = "llvmClangMerged";
    paths = with llvmPackages; [
      llvm
      (lib.getDev llvm)
      (lib.getLib llvm)
      clang-unwrapped
      (lib.getDev clang-unwrapped)
      (lib.getLib clang-unwrapped)
    ];
  };

  clangVersion = llvmPackages.clang-unwrapped.version;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "terra";
  version = "1.2.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "terralang";
    repo = "terra";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-DaV92X98GbVtOjp9rUEJTA8cZyCOqtzjAQd8idUOgoQ=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals enableCUDA [
    cudaPackages.cuda_nvcc
  ];
  buildInputs = [
    llvmMerged
    ncurses
    libffi
    libxml2
  ]
  ++ lib.optionals enableCUDA (
    with cudaPackages;
    [
      cuda_nvcc # crt/host_config.h; even though we include this in nativeBuildInputs, it's needed here too
      cuda_cudart
    ]
  )
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) libpfm;

  cmakeFlags =
    let
      resourceDir = "${llvmMerged}/lib/clang/${lib.versions.major clangVersion}";
    in
    [
      (lib.cmakeFeature "HAS_TERRA_VERSION" "0")
      (lib.cmakeFeature "TERRA_VERSION" finalAttrs.version)
      (lib.cmakeFeature "TERRA_LUA" "luajit")
      (lib.cmakeBool "TERRA_SKIP_LUA_DOWNLOAD" true)
      (lib.cmakeFeature "CLANG_RESOURCE_DIR" resourceDir)
    ]
    ++ lib.optionals enableCUDA [
      (lib.cmakeBool "TERRA_ENABLE_CUDA" true)
    ];

  doCheck = true;
  hardeningDisable = [ "fortify" ];
  outputs = [
    "bin"
    "dev"
    "out"
    "static"
  ];

  patches = [ ./nix-cflags.patch ];

  postPatch = ''
    substituteInPlace src/terralib.lua \
      --subst-var-by NIX_LIBC_INCLUDE ${lib.getDev stdenv.cc.libc}/include
  '';

  preConfigure = ''
    mkdir -p build
    ln -s ${luajitSrc} build/${luajitBase}
    tar --mode="a+rwX" -chzf build/${luajitArchive} -C build ${luajitBase}
    rm build/${luajitBase}
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $bin/bin bin/terra
    install -Dm755 -t $out/lib lib/terra${stdenv.hostPlatform.extensions.sharedLibrary}
    install -Dm644 -t $static/lib lib/libterra_s.a

    mkdir -pv $dev/include
    cp -rv include/terra $dev/include

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Low-level counterpart to Lua";
    homepage = "https://terralang.org/";
    downloadPage = "https://github.com/terralang/terra";
    changelog = "https://github.com/terralang/terra/blob/${finalAttrs.src.tag}/CHANGES.md";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      jb55
      seylerius
      thoughtpolice
      elliottslaughter
    ];
    license = lib.licenses.mit;
    mainProgram = "terra";
  };
})
