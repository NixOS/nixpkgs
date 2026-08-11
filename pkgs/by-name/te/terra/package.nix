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
  # https://github.com/terralang/terra/blob/0776e640ba9eb20c7d5419686ef106a38d8e18a3/cmake/Modules/GetLuaJIT.cmake#L19
  luajitRev = "04dca7911ea255f37be799c18d74c305b921c1a6";
  luajitBase = "LuaJIT-${luajitRev}";
  luajitArchive = "${luajitBase}.tar.gz";
  luajitSrc = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = luajitRev;
    hash = "sha256-IvkOwyKXUqo++A0XalCKuS0uLj5PlTOUQX1qXDP6JBk=";
  };

  llvmPackages = llvmPackages_22;
  llvmMerged = symlinkJoin {
    name = "llvmClangMerged";
    paths = with llvmPackages; [
      llvm.out
      llvm.dev
      llvm.lib
      clang-unwrapped.out
      clang-unwrapped.dev
      clang-unwrapped.lib
    ];
  };

  clangVersion = llvmPackages.clang-unwrapped.version;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "terra";
  version = "1.2.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "terralang";
    repo = "terra";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-K2AMNgqHBYIyPZ7wFocZcbQGlbrX7lyuks43pWqI4jU=";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optionals enableCUDA [ cudaPackages.cuda_nvcc ];
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
      "-DHAS_TERRA_VERSION=0"
      "-DTERRA_VERSION=${finalAttrs.version}"
      "-DTERRA_LUA=luajit"
      "-DTERRA_SKIP_LUA_DOWNLOAD=ON"
      "-DCLANG_RESOURCE_DIR=${resourceDir}"
    ]
    ++ lib.optional enableCUDA "-DTERRA_ENABLE_CUDA=ON";

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
