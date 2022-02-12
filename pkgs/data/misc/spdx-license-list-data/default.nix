{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "spdx-license-list-data";
  version = "3.16";

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "license-list-data";
    rev = "v${version}";
    sha256 = "1h6dj9lyfhk43b7f7ryxfzdf6v1bjq1zq6fmsqdkvdqpih87vwql";
  };

  # List of file formats to package.
  _types = "html json jsonld rdfa rdfnt rdfturtle rdfxml template text";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -ar $_types $out

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
