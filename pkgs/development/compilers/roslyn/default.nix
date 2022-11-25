{ lib
, fetchFromGitHub
, mono
, buildDotnetModule
, dotnetCorePackages
, unzip
}:

let
  packageVersion = "3.10.0";
in buildDotnetModule rec {
  pname = "roslyn";
  version = "${packageVersion}-1.21102.26";

  src = fetchFromGitHub {
    owner = "dotnet";
    repo = "roslyn";
    rev = "v${version}";
    sha256 = "0yf4f4vpqn9lixr37lkp29m2mk51xcm3ysv2ag332xn6zm5zpm2b";
  };

  dotnet-sdk = dotnetCorePackages.sdk_5_0;

  projectFile = [ "src/NuGet/Microsoft.Net.Compilers.Toolset/Microsoft.Net.Compilers.Toolset.Package.csproj" ];

  nugetDeps = ./extended-deps.nix;

  dontDotnetFixup = true;

  nativeBuildInputs = [ unzip ];

  buildPhase = ''
    runHook preBuild

    dotnet msbuild -v:m -t:pack \
      -p:Configuration=Release \
      -p:RepositoryUrl="${meta.homepage}" \
      -p:RepositoryCommit="v${version}" \
      src/NuGet/Microsoft.Net.Compilers.Toolset/Microsoft.Net.Compilers.Toolset.Package.csproj

    runHook postBuild
  '';

  installPhase = ''
    pkg="$out/lib/dotnet/microsoft.net.compilers.toolset/${packageVersion}"
    mkdir -p "$out/bin" "$pkg"

    unzip -q artifacts/packages/Release/Shipping/Microsoft.Net.Compilers.Toolset.${packageVersion}-dev.nupkg \
      -d "$pkg"
    # nupkg has 0 permissions for a bunch of things
    chmod -R +rw "$pkg"

    makeWrapper ${mono}/bin/mono $out/bin/csc \
      --add-flags "$pkg/tasks/net472/csc.exe"
    makeWrapper ${mono}/bin/mono $out/bin/vbc \
      --add-flags "$pkg/tasks/net472/vbc.exe"
  '';

  meta = with lib; {
    mainProgram = "csc";
    description = ".NET C# and Visual Basic compiler";
    homepage = "https://github.com/dotnet/roslyn";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ corngood ];
  };
}
