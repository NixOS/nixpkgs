{
  lib,
  fetchFromGitHub,
  fetchurl,
  nodejs,
  stdenv,
  makeWrapper,
  autoPatchelfHook,
  versionCheckHook,
  testers,
  # Linux dependencies
  xorg,
  libxkbcommon,
  fontconfig,
  freetype,
  at-spi2-core,
  libGL,
  libGLU,
  mesa,
  libglvnd,
  pipewire,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "terminator-mcp-agent";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "mediar-ai";
    repo = "terminator";
    rev = "117cefaab19886ccd835b879f35f4d170d73a4ae";
    hash = "sha256-dkKzEOMbBYZB5DTi50tO/IuP9n4wsNShH6lif+Bl7Gk=";
  };

  # Platform-specific binary sources
  platformBinary = let
    sources = {
      "x86_64-linux" = {
        url = "https://registry.npmjs.org/terminator-mcp-linux-x64-gnu/-/terminator-mcp-linux-x64-gnu-${finalAttrs.version}.tgz";
        hash = "sha256-G+sjKWwYJtxrqiuFBv9PwTuSS4vrb5YchkKBcE/hPyg=";
      };
      "x86_64-darwin" = {
        url = "https://registry.npmjs.org/terminator-mcp-darwin-x64/-/terminator-mcp-darwin-x64-${finalAttrs.version}.tgz";
        hash = "sha256-Pq8hva7v0ZThBV5jJ+X0xbspgXuKqXP4kKHLWzrrRw4=";
      };
      "aarch64-darwin" = {
        url = "https://registry.npmjs.org/terminator-mcp-darwin-arm64/-/terminator-mcp-darwin-arm64-${finalAttrs.version}.tgz";
        hash = "sha256-T3OsckuQA220cM6AzueBepiCtJhp8G1hVdq1Yaofm68=";
      };
    };
    platformData = sources.${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}. Supported platforms: ${lib.concatStringsSep ", " (lib.attrNames sources)}");
  in
    fetchurl platformData;

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  nativeInstallCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [
    versionCheckHook
  ];

  buildInputs = [
    nodejs
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    xorg.libX11
    xorg.libXrandr
    xorg.libXi
    xorg.libXext
    xorg.libXtst
    libxkbcommon
    fontconfig
    freetype
    at-spi2-core
    # Additional graphics libraries
    libGL
    libGLU
    mesa
    libglvnd
    pipewire
  ];

  # No build phase needed, just install
  dontBuild = true;
  dontConfigure = true;
  dontUnpack = false; # We need to unpack for the Node.js files

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/bin $out/lib/terminator-mcp-agent
    
    # Install the Node.js wrapper and config files
    cp terminator-mcp-agent/index.js $out/lib/terminator-mcp-agent/
    cp terminator-mcp-agent/config.js $out/lib/terminator-mcp-agent/
    cp terminator-mcp-agent/package.json $out/lib/terminator-mcp-agent/
    
    # Extract and install the platform-specific binary
    mkdir -p /tmp/terminator-extract
    tar -xzf ${finalAttrs.platformBinary} -C /tmp/terminator-extract
    
    # Copy the binary (try common locations)
    if [ -f /tmp/terminator-extract/package/bin/terminator-mcp-agent ]; then
      cp /tmp/terminator-extract/package/bin/terminator-mcp-agent $out/bin/
    elif [ -f /tmp/terminator-extract/package/terminator-mcp-agent ]; then
      cp /tmp/terminator-extract/package/terminator-mcp-agent $out/bin/
    else
      echo "Could not find terminator-mcp-agent binary in platform package" >&2
      echo "Contents of extracted package:" >&2
      find /tmp/terminator-extract -type f -name "*terminator*" || true
      exit 1
    fi
    
    chmod +x $out/bin/terminator-mcp-agent
    
    # Create a Node.js wrapper script
    cat > $out/bin/terminator-mcp-agent-nodejs << 'EOF'
#!/usr/bin/env node
const path = require('path');
const { spawn } = require('child_process');

// Set up paths
const libDir = path.join(__dirname, '..', 'lib', 'terminator-mcp-agent');
const binaryPath = path.join(__dirname, 'terminator-mcp-agent');

// Load the configuration module
const config = require(path.join(libDir, 'config.js'));

// Get command line arguments
const args = process.argv.slice(2);

// Handle --add-to-app configuration
if (args.includes('--add-to-app')) {
  const appIndex = args.indexOf('--add-to-app') + 1;
  const app = args[appIndex] && !args[appIndex].startsWith('--') ? args[appIndex] : undefined;
  
  if (!app) {
    console.log('Configuration mode requires specifying an app');
    console.log('Usage: terminator-mcp-agent-nodejs --add-to-app <app-name>');
    console.log('Supported apps: claude, cursor, zed, etc.');
    process.exit(1);
  }
  
  try {
    const currentConfig = config.readConfig(app);
    currentConfig.mcpServers = currentConfig.mcpServers || {};
    currentConfig.mcpServers['terminator-mcp-agent'] = {
      command: binaryPath,
      args: []
    };
    config.writeConfig(currentConfig, app);
    console.log('Configured MCP for ' + app);
  } catch (e) {
    console.error('Failed to configure MCP for ' + app + ':', e.message);
    process.exit(1);
  }
  
  process.exit(0);
}

// Otherwise, run the binary directly
const child = spawn(binaryPath, args, {
  stdio: 'inherit',
  shell: false
});

child.on('exit', (code) => {
  process.exit(code);
});

// Handle signals
process.on('SIGINT', () => {
  if (child && !child.killed) {
    child.kill('SIGINT');
  }
});

process.on('SIGTERM', () => {
  if (child && !child.killed) {
    child.kill('SIGTERM');
  }
});
EOF
    
    chmod +x $out/bin/terminator-mcp-agent-nodejs
    
    # Wrap both binaries
    wrapProgram $out/bin/terminator-mcp-agent \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]}
    
    wrapProgram $out/bin/terminator-mcp-agent-nodejs \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]} \
      --set NODE_PATH $out/lib/terminator-mcp-agent
    
    runHook postInstall
  '';

  # Version checking (only on Linux for now due to cross-compilation issues)
  doInstallCheck = stdenv.hostPlatform.isLinux;
  versionCheckProgram = "${placeholder "out"}/bin/terminator-mcp-agent";
  versionCheckProgramArg = "--version";

  passthru = {
    tests = {
      version = testers.testVersion { 
        package = finalAttrs.finalPackage; 
        command = "terminator-mcp-agent --version";
      };
      nodejs-wrapper = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "terminator-mcp-agent-nodejs --help";
        version = "Usage: terminator-mcp-agent";
      };
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Cross-platform Model Context Protocol (MCP) agent for desktop automation";
    longDescription = ''
      Terminator MCP Agent is a Model Context Protocol server that provides desktop
      GUI automation capabilities for Windows, macOS, and Linux. It allows AI agents
      to interact with desktop applications programmatically through the MCP protocol.
      
      This package uses pre-built binaries from the npm distribution for reliability
      and includes both the native binary and a Node.js wrapper for easy integration
      with AI applications that support the Model Context Protocol.
    '';
    homepage = "https://github.com/mediar-ai/terminator";
    changelog = "https://github.com/mediar-ai/terminator/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsl11; # Business Source License 1.1 - requires NIXPKGS_ALLOW_UNFREE=1
    maintainers = with lib.maintainers; [ connerohnesorge ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "terminator-mcp-agent-nodejs";
  };
})
