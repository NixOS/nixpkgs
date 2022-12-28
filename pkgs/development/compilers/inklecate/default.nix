{ lib
, stdenv
, autoPatchelfHook
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
}:

buildDotnetModule rec {
  pname = "inklecate";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "inkle";
    repo = "ink";
    rev = "v${version}";
    sha256 = "00lagmwsbxap5mgnw4gndpavmv3xsgincdaq1zvw7fkc3vn3pxqc";
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];

  projectFile = "inklecate/inklecate.csproj";
  nugetDeps = ./deps.nix;
  executables = [ "inklecate" ];

  dotnet-runtime = dotnetCorePackages.runtime_3_1;
  dotnet-sdk = dotnetCorePackages.sdk_3_1;

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
