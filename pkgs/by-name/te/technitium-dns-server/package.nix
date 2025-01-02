{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  technitium-dns-server-library,
  nixosTests,
  nix-update-script,
}:
buildDotnetModule rec {
  pname = "technitium-dns-server";
  version = "13.2";

  src = fetchFromGitHub {
    owner = "TechnitiumSoftware";
    repo = "DnsServer";
    rev = "refs/tags/v${version}";
    hash = "sha256-oxLMBs+XkzvlfSst6ZD56ZIgiXwm0Px8Tn3Trdd/6H8=";
    name = "${pname}-${version}";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

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
