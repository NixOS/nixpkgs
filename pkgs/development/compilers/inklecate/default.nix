{ lib
, stdenv
, autoPatchelfHook
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
}:

buildDotnetModule rec {
  pname = "inklecate";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "inkle";
    repo = "ink";
    rev = "v${version}";
    hash = "sha512-aUjjT5Qf64wrKRn1vkwJadMOBWMkvsXUjtZ7S3/ZWAh1CCDkQNO84mSbtbVc9ny0fKeJEqaDX2tJNwq7pYqAbA==";
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];

  projectFile = "inklecate/inklecate.csproj";
  nugetDeps = ./deps.nix;
  executables = [ "inklecate" ];

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  meta = with lib; {
    description = "Compiler for ink, inkle's scripting language";
    longDescription = ''
      Inklecate is a command-line compiler for ink, inkle's open source
      scripting language for writing interactive narrative
    '';
    homepage = "https://www.inklestudios.com/ink/";
    downloadPage = "https://github.com/inkle/ink/";
    license = licenses.mit;
    platforms = platforms.unix;
    badPlatforms = platforms.aarch64;
    maintainers = with maintainers; [ shreerammodi ];
  };
}
