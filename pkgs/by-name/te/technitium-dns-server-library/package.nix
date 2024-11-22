{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  nix-update-script,
}:
buildDotnetModule rec {
  pname = "technitium-dns-server-library";
  version = "dns-server-v13.2";

  src = fetchFromGitHub {
    owner = "TechnitiumSoftware";
    repo = "TechnitiumLibrary";
    rev = "refs/tags/${version}";
    hash = "sha256-stfxYe0flE1daPuXw/GAgY52ZD7pkqnBIBvmSVPWWjI=";
    name = "${pname}-${version}";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  nugetDeps = ./nuget-deps.nix;

  projectFile = [
    "TechnitiumLibrary.ByteTree/TechnitiumLibrary.ByteTree.csproj"
    "TechnitiumLibrary.Net/TechnitiumLibrary.Net.csproj"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/TechnitiumSoftware/DnsServer/blob/master/CHANGELOG.md";
    description = "Library for Authorative and Recursive DNS server for Privacy and Security";
    homepage = "https://github.com/TechnitiumSoftware/DnsServer";
    license = lib.licenses.gpl3Only;
    mainProgram = "technitium-dns-server-library";
    maintainers = with lib.maintainers; [ fabianrig ];
    platforms = lib.platforms.linux;
  };
}
