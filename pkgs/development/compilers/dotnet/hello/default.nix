{ stdenv
, buildDotnetModule
, dotnet-sdk
}: let finalPackage = buildDotnetModule {
  name = "dotnet-console-template";

  nativeBuildInputs = [ dotnet-sdk ];

  unpackPhase = ''
    dotnet new console -n hello
    rm -fr hello/obj
  '';

  sourceRoot = "hello";

  nugetDeps = ./deps.nix;

  projectFile = "hello.csproj";

  passthru.tests = {
    smoke-test = stdenv.mkDerivation {
      name = "dotnet-console-template-test";
      nativeBuildInputs = [ finalPackage ];
      buildCommand = ''
        output=$(hello)
        [ "$output" = "Hello, World!" ] && touch "$out"
      '';
    };
  };
}; in finalPackage
