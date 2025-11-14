{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  technitium-dns-server-library,
  libmsquic,
  nixosTests,
  nix-update-script,
}:
buildDotnetModule rec {
  pname = "technitium-dns-server";
  version = "14.0.0";

  src = fetchFromGitHub {
    owner = "TechnitiumSoftware";
    repo = "DnsServer";
    tag = "v${version}";
    hash = "sha256-h7lcm9gKaCIPccg4Mxp78qSgygAuFyRPd1jPfmkoarU=";
    name = "${pname}-${version}";
  };

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;

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

  passthru.updateScript = nix-update-script { };

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
