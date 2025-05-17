{
  lib,
  stdenv,
  callPackage,
  vscode-generic,
  fetchurl,
  nixosTests,
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.isDarwin,
}:

let
  pname = "void-editor";
  version = "1.99.30001";

  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${system}";

  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

  mkFetchurl =
    { plat, hash }:
    fetchurl {
      url = "https://github.com/voideditor/binaries/releases/download/${version}/Void-${plat}-${version}.${archive_fmt}";
      inherit hash;
    };

  sources = {
    x86_64-linux = mkFetchurl {
      plat = "linux-x64";
      hash = "sha256-coq6oY/FAKMhLpaT0YN/8OLBYRt00sUKEobkAjCSsWs=";
    };
    aarch64-linux = mkFetchurl {
      plat = "darwin-x64";
      hash = "sha256-MXo9Zg6XebszqDQT5U3xEisj/MpRKgQfoPAAqDz4mU8=";
    };
    x86_64-darwin = mkFetchurl {
      plat = "linux-arm64";
      hash = "sha256-gfujUR2NYhwyj5FE+AsrMVPqW5gE5P85uvdR67r4P8E=";
    };
    aarch64-darwin = mkFetchurl {
      plat = "darwin-arm64";
      hash = "sha256-Gfe/IcKbL8OT2NEAOzA5NC1S54Qgl9/6hGSCUUsqhPY=";
    };
    armv7l-linux = mkFetchurl {
      plat = "linux-armhf";
      hash = "sha256-WQjWvCaaqBnMbA0vFijLOMYwRNAay4EucUAkp/iwCws=";
    };
  };

  sourceRoot = lib.optionalString (!stdenv.isDarwin) ".";
in
(callPackage vscode-generic rec {
  inherit
    sourceRoot
    commandLineArgs
    useVSCodeRipgrep
    pname
    version
    ;

  # Please backport all compatible updates to the stable release.
  # This is important for the extension ecosystem.
  executableName = "void";
  longName = "Void Editor";
  shortName = "void";

  src = sources.${system} or throwSystem;

  tests = nixosTests.vscodium;

  updateScript = ./update-void-editor.sh;

  meta = with lib; {
    description = ''
      Void is the open-source Cursor alternative.
    '';
    longDescription = ''
      Open source source code editor fork of VSCode adding integrated
      agentic code assitant features, akin to Cursor (i.e., code-cursor).
    '';
    homepage = "https://voideditor.com";
    downloadPage = "https://github.com/voideditor/binaries/releases";
    license = licenses.apsl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ jskrzypek ];
    mainProgram = "void";
    platforms = builtins.attrNames sources;
  };
})
// {
  inherit sources;
}
