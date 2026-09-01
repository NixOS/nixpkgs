{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  technitium-dns-server-library,
  libmsquic,
  nixosTests,
}:
buildDotnetModule (finalAttrs: {
  pname = "technitium-dns-server";
  version = "15.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "TechnitiumSoftware";
    repo = "DnsServer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EPqaVulPO5giURtlmj4vMDXYFKICrhJa9TQbQ9AaYJ8=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  nugetDeps = ./nuget-deps.json;

  projectFile = [ "DnsServerApp/DnsServerApp.csproj" ];

  # move dependencies from TechnitiumLibrary to the expected directory
  preBuild = ''
    mkdir -p ../TechnitiumLibrary/bin
    cp -r ${technitium-dns-server-library}/lib/${technitium-dns-server-library.pname}/* ../TechnitiumLibrary/bin/
  '';

  postFixup = ''
    mv $out/bin/DnsServerApp $out/bin/technitium-dns-server
  '';

  runtimeDeps = [
    libmsquic
  ];

  passthru.tests = {
    inherit (nixosTests) technitium-dns-server;
  };

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/TechnitiumSoftware/DnsServer/blob/master/CHANGELOG.md";
    description = "Authoritative and Recursive DNS server for Privacy and Security";
    homepage = "https://github.com/TechnitiumSoftware/DnsServer";
    license = lib.licenses.gpl3Only;
    mainProgram = "technitium-dns-server";
    maintainers = with lib.maintainers; [
      fabianrig
      awildleon
    ];
    platforms = lib.platforms.linux;
  };
})
