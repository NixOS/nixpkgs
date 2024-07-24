{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  nixosTests,
}:
let
  technitium-library = buildDotnetModule rec {
    pname = "TechnitiumLibrary";
    version = "570ec570b57d8591daa3df682ca9e6f37f373db6";

    src = fetchFromGitHub {
      owner = "TechnitiumSoftware";
      repo = "TechnitiumLibrary";
      rev = version;
      hash = "sha256-xPwRoRp/XYrlGX3B9EiHUz2Tueh+hygbBopxFvdASLQ";
      name = "${pname}-${version}";
    };

    dotnet-sdk = dotnetCorePackages.sdk_8_0;

    nugetDeps = ./library-nuget-deps.nix;

    projectFile = [
      "TechnitiumLibrary.ByteTree/TechnitiumLibrary.ByteTree.csproj"
      "TechnitiumLibrary.Net/TechnitiumLibrary.Net.csproj"
    ];
  };
in
buildDotnetModule rec {
  pname = "technitium-dns-server";
  version = "12.2.1";

  src = fetchFromGitHub {
    owner = "TechnitiumSoftware";
    repo = "DnsServer";
    rev = "refs/tags/v${version}";
    hash = "sha256-2RB/pUlA9z7TJ4xd509nsbO1BnxY3mv2jou6OGRd/yM=";
    name = "${pname}-${version}";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  nugetDeps = ./nuget-deps.nix;

  projectFile = [ "DnsServerApp/DnsServerApp.csproj" ];

  # move dependencies from TechnitiumLibrary to the expected directory
  preBuild = ''
    mkdir -p ../TechnitiumLibrary/bin
    cp -r ${technitium-library}/lib/TechnitiumLibrary/* ../TechnitiumLibrary/bin/
  '';

  postFixup = ''
    mv $out/bin/DnsServerApp $out/bin/technitium-dns-server
  '';

  passthru.tests = {
    inherit (nixosTests) technitium-dns-server;
  };

  meta = {
    changelog = "https://github.com/TechnitiumSoftware/DnsServer/blob/master/CHANGELOG.md";
    description = "Authorative and Recursive DNS server for Privacy and Security";
    homepage = "https://github.com/TechnitiumSoftware/DnsServer";
    license = lib.licenses.gpl3Only;
    mainProgram = "technitium-dns-server";
    maintainers = with lib.maintainers; [ fabianrig ];
    platforms = lib.platforms.linux;
  };
}
