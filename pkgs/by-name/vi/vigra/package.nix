{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  doxygen,
  fftw,
  fftwSinglePrec,
  hdf5,
  libjpeg,
  libpng,
  libtiff,
  openexr,
  python3,
  versionCheckHook,
  writeShellScript,
  jq,
  nix-update,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vigra";
  version = "1.12.3";

  outputs = [ "out" ];

  src = fetchFromGitHub {
    owner = "ukoethe";
    repo = "vigra";
    tag = "Version-${lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-pknZHHIIhjfOxdp+qCOOGvo0W5ByTHXRiIQzzN7Z6M4=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    fftw
    fftwSinglePrec
    (hdf5.override {
      apiVersion = "v110";
    })
    libjpeg
    libpng
    libtiff
    openexr
  ];

  postPatch = ''
    chmod +x config/run_test.sh.in
    patchShebangs --build config/run_test.sh.in

    substituteInPlace vigranumpy/CMakeLists.txt  \
      --replace-fail "''${CMAKE_INSTALL_PREFIX}/include" "''${CMAKE_INSTALL_INCLUDEDIR}"

    substituteInPlace config/vigra-config.in \
      --replace-fail "@CMAKE_INSTALL_PREFIX@/include" "@CMAKE_INSTALL_INCLUDEDIR@"
  '';

  cmakeFlags = [
    "-DWITH_OPENEXR=1"
  ]
  ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
    "-DCMAKE_CXX_FLAGS=-fPIC"
    "-DCMAKE_C_FLAGS=-fPIC"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p "$out/bin"
    # vigra builds vigra-config unconditionally,
    # but somehow won't install vigra-config without the presence of Python3 and NumPy at build time.
    # Let's install it manually as needed.
    if [[ ! -e "''$out/bin/vigra-config" ]] && [[ ! -e "''${!outputDev}/bin/vigra-config" ]]; then
      install -m755 bin/vigra-config "$out/bin/vigra-config"
    fi
  '';

  preFixup = ''
    moveToOutput bin/vigra-config "''${!outputDev}"
    # In case python3 is available
    patchShebangs --build "''${!outputDev}/bin/vigra-config"
  '';

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  preInstallCheck = ''
    vigraConfigInstallPath="''${!outputDev}/bin/vigra-config"
    if command -v python3; then
      # Take this opportunity to test vigra-config
      versionCheckProgram=$vigraConfigInstallPath
      versionCheckProgramArg=--version
    else
      versionCheckProgram=$(command -v cat)
      versionCheckProgramArg=$vigraConfigInstallPath
    fi
  '';

  passthru = {
    doc =
      (finalAttrs.overrideAttrs (
        finalAttrs: previousAttrs: {
          outputs = [
            "out"
            "doc"
          ];
          cmakeFlags = [
            (lib.cmakeBool "BUILD_DOCS" true)
            (lib.cmakeBool "CMAKE_SKIP_INSTALL_ALL_DEPENDENCY" true)
          ];
          postPatch = previousAttrs.postPatch or "" + ''
            substituteInPlace src/impex/CMakeLists.txt \
              --replace-fail "INSTALL(TARGETS vigraimpex" "INSTALL(TARGETS vigraimpex OPTIONAL"
          '';
          nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
            doxygen
            python3
          ];
          buildInputs = [
            python3
          ];
          buildFlags = [
            "doc"
          ];
          passthru = removeAttrs previousAttrs.passthru [ "doc" ];
        }
      )).doc;
    tests = {
      check = finalAttrs.overrideAttrs (previousAttrs: {
        doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
      });
      inherit (finalAttrs.passthru) doc;
    };
    updateScript = writeShellScript "update-vigra" ''
      latestVersion=$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --fail --silent https://api.github.com/repos/ukoethe/vigra/releases/latest | ${lib.getExe jq} --raw-output .tag_name | sed -E 's/Version-([0-9]+)-([0-9]+)-([0-9]+)/\1.\2.\3/')
      ${lib.getExe nix-update} vigra --version $latestVersion
    '';
  };

  meta = {
    description = "Novel computer vision C++ library with customizable algorithms and data structures";
    mainProgram = "vigra-config";
    homepage = "https://hci.iwr.uni-heidelberg.de/vigra";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ShamrockLee
      kyehn
    ];
    platforms = lib.platforms.unix;
  };
})
