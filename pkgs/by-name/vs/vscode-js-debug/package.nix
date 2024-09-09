{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, buildPackages
, libsecret
, xcbuild
, Security
, AppKit
, pkg-config
, node-gyp
, runCommand
, vscode-js-debug
, nix-update-script
}:

buildNpmPackage rec {
  pname = "vscode-js-debug";
  version = "1.91.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-js-debug";
    rev = "v${version}";
    hash = "sha256-3SZIIBHv599qLaW419CA0Nr7F6R7GB9wqUnOqbV4jKc=";
  };

  npmDepsHash = "sha256-kZ5wCcmdpYtT6dqtV3i8R9LKFs20sq0rZC1W1w00XJQ=";

  nativeBuildInputs = [
    pkg-config
    node-gyp
  ] ++ lib.optionals stdenv.isDarwin [ xcbuild ];

  buildInputs =
    lib.optionals (!stdenv.isDarwin) [ libsecret ]
    ++ lib.optionals stdenv.isDarwin [
      Security
      AppKit
    ];

  postPatch = ''
    ${lib.getExe buildPackages.jq} '
      .scripts.postinstall |= empty |             # tries to install playwright, not necessary for build
      .scripts.build |= "gulp dapDebugServer" |   # there is no build script defined
      .bin |= "./dist/src/dapDebugServer.js"      # there is no bin output defined
    ' ${src}/package.json > package.json
  '';

  makeCacheWritable = true;

  npmInstallFlags = [ "--include=dev" ];

  preBuild = ''
    export PATH="node_modules/.bin:$PATH"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex" "v((?!\d{4}\.\d\.\d{3}).*)" ];
  };

  passthru.tests.test = runCommand "${pname}-test"
    {
      nativeBuildInputs = [ vscode-js-debug ];
      meta.timeout = 60;
    } ''
    output=$(js-debug --help 2>&1)
    if grep -Fw -- "Usage: dapDebugServer.js [port|socket path=8123] [host=localhost]" - <<< "$output"; then
      touch $out
    else
      echo "Expected help output was not found!" >&2
      echo "The output was:" >&2
      echo "$output" >&2
      exit 1
    fi
  '';

  meta = with lib; {
    description = "A DAP-compatible JavaScript debugger";
    longDescription = ''
      This is a [DAP](https://microsoft.github.io/debug-adapter-protocol/)-based
      JavaScript debugger. It debugs Node.js, Chrome, Edge, WebView2, VS Code
      extensions, and more. It has been the default JavaScript debugger in
      Visual Studio Code since 1.46, and is gradually rolling out in Visual
      Studio proper.
    '';
    homepage = "https://github.com/microsoft/vscode-js-debug";
    changelog =
      "https://github.com/microsoft/vscode-js-debug/blob/v${version}/CHANGELOG.md";
    mainProgram = "js-debug";
    license = licenses.mit;
    maintainers = with maintainers; [ zeorin ];
  };
}
