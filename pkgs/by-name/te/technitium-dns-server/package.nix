{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  dotnet-sdk_8,
}:
stdenvNoCC.mkDerivation rec {
  pname = "technitium-dns-server";
  version = "12.1";

  src = fetchurl {
    url = "https://download.technitium.com/dns/archive/${version}/DnsServerPortable.tar.gz";
    hash = "sha256-G0M2xuYBZA3XXXaPs4pLrJmzAMbVJhiqISAvuCw3iZo=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/.
    rm $out/share/${pname}-${version}/start.{sh,bat}
    rm $out/share/${pname}-${version}/DnsServerApp.exe
    rm $out/share/${pname}-${version}/env-vars
    # Remove systemd.service in favor of a separate module (including firewall configuration).
    rm $out/share/${pname}-${version}/systemd.service

    makeWrapper "${dotnet-sdk_8}/bin/dotnet" $out/bin/technitium-dns-server \
      --add-flags "$out/share/${pname}-${version}/DnsServerApp.dll"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/TechnitiumSoftware/DnsServer/blob/master/CHANGELOG.md";
    description = "Authorative and Recursive DNS server for Privacy and Security";
    homepage = "https://github.com/TechnitiumSoftware/DnsServer";
    license = lib.licenses.gpl3Only;
    mainProgram = "technitium-dns-server";
    maintainers = with lib.maintainers; [ fabianrig ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}
