{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:
buildDotnetModule (finalAttrs: {
  pname = "technitium-dns-server-library";
  version = "15.6.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "TechnitiumSoftware";
    repo = "TechnitiumLibrary";
    tag = "dns-server-${finalAttrs.version}";
    hash = "sha256-fb5o4AlKFU/oPypD7T3sNoUdY7nHS4skGovDSLNzpI0=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;

  nugetDeps = ./nuget-deps.json;

  projectFile = [
    "TechnitiumLibrary.ByteTree/TechnitiumLibrary.ByteTree.csproj"
    "TechnitiumLibrary.Net/TechnitiumLibrary.Net.csproj"
    "TechnitiumLibrary.Security.OTP/TechnitiumLibrary.Security.OTP.csproj"
  ];

  meta = {
    changelog = "https://github.com/TechnitiumSoftware/DnsServer/blob/master/CHANGELOG.md";
    description = "Library for Authoritative and Recursive DNS server for Privacy and Security";
    homepage = "https://github.com/TechnitiumSoftware/DnsServer";
    license = lib.licenses.gpl3Only;
    mainProgram = "technitium-dns-server-library";
    maintainers = with lib.maintainers; [
      fabianrig
      awildleon
    ];
    platforms = lib.platforms.linux;
  };
})
