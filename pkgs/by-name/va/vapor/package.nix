{
  lib,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vapor";
  version = "4.105.0";

  src = fetchFromGitHub {
    owner = "vapor";
    repo = "vapor";
    rev = "7aa836b77626bf07e71d5f50b9ad87cbe439ed81";
    hash = "sha256-AyuxnJFUoo+l5xOCyXl74dh/WzH9TiZmNLzPAT0P7uM=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
        runHook preInstall
        # Install the package sources and manifest for Swift Package Manager integration
        mkdir -p $out/share/vapor
        cp -r Sources/ $out/share/vapor/
        cp Package.swift $out/share/vapor/
        cp -r README.md LICENSE $out/share/vapor/ 2>/dev/null || true
        # Create a simple wrapper script for easy Swift Package Manager usage
        mkdir -p $out/bin
        cat > $out/bin/vapor-version << 'EOF'
    #!/bin/sh
    echo "Vapor ${finalAttrs.version}"
    echo "Sources available at: $out/share/vapor"
    echo "To use in your Swift project, add the following to your Package.swift:"
    echo '.package(path: "'$out'/share/vapor")'
    EOF
        chmod +x $out/bin/vapor-version
        runHook postInstall
  '';

  passthru.updateScript = nix-update-script { attrPath = finalAttrs.pname; };

  meta = {
    description = "Server-side Swift HTTP web framework";
    longDescription = ''
      Vapor is an HTTP web framework for Swift. It provides a beautifully
      expressive and easy-to-use foundation for your next website, API, or
      cloud project. Built with a non-blocking, event-driven architecture,
      Vapor allows you to build high-performant, scalable APIs and HTTP servers.
    '';
    homepage = "https://vapor.codes";
    changelog = "https://github.com/vapor/vapor/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fbettag ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})
