{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "spdx-license-list-data";
  version = "3.14";

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "license-list-data";
    rev = "v${version}";
    sha256 = "07fl31732bvcmm93fqrpa7pfq5ynxc1fpd8n9w2iah39lyz49sjm";
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
