{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "spdx-license-list-data";
  version = "3.13";

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "license-list-data";
    rev = "v${version}";
    sha256 = "184qfz8jifkd4jvqkdfmcgplf12cdx83gynb7mxzmkfg2xymlr0g";
  };

  installPhase = ''
    runHook preInstall

    install -vDt $out/json json/licenses.json

    runHook postInstall
  '';

  meta = with lib; {
    description = "Various data formats for the SPDX License List";
    homepage = "https://github.com/spdx/license-list-data";
    license = licenses.cc0;
    maintainers = with maintainers; [ oxzi ];
    platforms = platforms.all;
  };
}
