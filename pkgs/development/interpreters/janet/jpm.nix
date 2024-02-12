{ lib, stdenv, fetchFromGitHub, janet }:

let
  platformFiles = {
    aarch64-darwin = "macos_config.janet";
    aarch64-linux = "linux_config.janet";
    x86_64-darwin = "macos_config.janet";
    x86_64-linux = "linux_config.janet";
  };

  platformFile = platformFiles.${stdenv.hostPlatform.system};

in
stdenv.mkDerivation rec {
  pname = "jpm";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lPB4jew6RkJlDp8xOQ4YA9MkgLBImaBHcvv4WF/sLRc=";
  };

  # `auto-shebangs true` gives us a shebang line that points to janet inside the
  # jpm bin folder
  postPatch = ''
    substituteInPlace configs/${platformFile} \
      --replace 'auto-shebang true' 'auto-shebang false' \
      --replace /usr/local $out
  '';

  dontConfigure = true;

  buildInputs = [ janet ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib/janet,share/man/man1}

    janet bootstrap.janet configs/${platformFile}

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/jpm help
  '';

  meta = janet.meta // {
    description = "Janet Project Manager for the Janet programming language";
    platforms = lib.attrNames platformFiles;
  };
}
