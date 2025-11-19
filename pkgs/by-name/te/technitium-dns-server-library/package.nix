{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  nix-update-script,
}:
buildDotnetModule rec {
  pname = "technitium-dns-server-library";
  version = "dns-server-v14.0.0";

  src = fetchFromGitHub {
    owner = "TechnitiumSoftware";
    repo = "TechnitiumLibrary";
    tag = version;
    hash = "sha256-vQAYNXSXWWuEMLj+zWQIM5A4BYcyiUlfp7+Ttk4R+MA=";
    name = "${pname}-${version}";
  };

  dotnet-sdk = dotnetCorePackages.sdk_9_0;

  nugetDeps = ./nuget-deps.json;

  projectFile = [
    "TechnitiumLibrary.ByteTree/TechnitiumLibrary.ByteTree.csproj"
    "TechnitiumLibrary.Net/TechnitiumLibrary.Net.csproj"
    "TechnitiumLibrary.Security.OTP/TechnitiumLibrary.Security.OTP.csproj"
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
