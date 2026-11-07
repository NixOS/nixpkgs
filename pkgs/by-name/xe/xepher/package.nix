{
  lib,
  clangStdenv,
  bison,
  cmake,
  flex,
  ninja,
  pkg-config,
  fetchFromGitHub,
  weechat,
  weechat-unwrapped,
  libstrophe,
  libxml2,
  lmdb,
  libsignal-protocol-c,
  libomemo-c,
  gpgme,
  libgcrypt,
  fmt,
  curl,
  openssl,
  runCommand,
}:

# GCC 16 treats warn_unused_result as an error under -Werror. Upstream
# develops and releases this plugin with Clang.
clangStdenv.mkDerivation (finalAttrs: {
  pname = "xepher";
  version = "1.1.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ekollof";
    repo = "xepher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WoiinRYab/ClVe3mfPQWdtiYcGi/DuJjRmI6aVUIYbo=";
  };

  # The makefile configures CMake itself and writes xmpp.so in the source
  # root. The nixpkgs CMake hook would configure first and leave the builder
  # in build/, so install would miss the module.
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    bison
    cmake
    flex
    ninja
    pkg-config
  ];

  buildInputs = [
    # FlexLexer.h is compiled into the lexer. strictDeps does not put
    # nativeBuildInputs headers on the host include path.
    flex
    weechat-unwrapped
    libstrophe
    libxml2
    lmdb
    libsignal-protocol-c
    libomemo-c
    gpgme
    libgcrypt
    fmt
    curl
    openssl
  ];

  buildPhase = ''
    runHook preBuild
    make PACKAGE_BUILD=1 weechat-xmpp
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 xmpp.so "$out/lib/weechat/plugins/xmpp.so"
    install -Dm644 scripts/icat.py "$out/share/weechat/python/icat.py"
    install -Dm644 scripts/feed_compose.py "$out/share/weechat/python/feed_compose.py"
    install -Dm644 README.md "$out/share/doc/xepher/README.md"
    install -Dm644 LICENSE "$out/share/licenses/xepher/LICENSE"
    runHook postInstall
  '';

  passthru.tests.load-plugin =
    runCommand "${finalAttrs.pname}-test-load"
      {
        nativeBuildInputs = [ weechat ];
      }
      ''
        weechat -t -d "$(mktemp -d)" \
          --run-command "/plugin load ${finalAttrs.finalPackage}/lib/weechat/plugins/xmpp.so ; /quit" \
          2>&1 | tee log
        if grep -q 'Plugin "xmpp" loaded' log; then
          echo "Check passed: xmpp plugin loaded into WeeChat."
          touch $out
        else
          echo "Check failed: 'xmpp' not found in WeeChat output."
          exit 1
        fi
      '';

  meta = {
    description = "WeeChat plugin for XMPP";
    homepage = "https://ekollof.github.io/xepher/";
    changelog = "https://github.com/ekollof/xepher/releases/tag/v${finalAttrs.version}";
    longDescription = ''
      Xepher is a WeeChat plugin for XMPP, with OMEMO and message archive
      support.

      The WeeChat wrapper autoloads only the language plugins it was built
      with. Load this module by its store path:

        /plugin load <xepher>/lib/weechat/plugins/xmpp.so

      Companion Python scripts are installed under
      $out/share/weechat/python/.
    '';
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ ekollof ];
    platforms = lib.platforms.linux;
  };
})
