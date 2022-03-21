{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "spdx-license-list-data";
  version = "3.16";

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "license-list-data";
    rev = "v${version}";
    hash = "sha256-FPN9EIwXtz0b1tUZ/AOWK2zj2nfd5+POGmRC52mSzcA=";
  };

  # List of file formats to package.
  _types = [ "html" "json" "jsonld" "rdfa" "rdfnt" "rdfturtle" "rdfxml" "template" "text" ];

  outputs = [ "out" ] ++ _types;

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -pv $out
    for t in $_types
    do
      _outpath=''${!t}
      mkdir -pv $_outpath
      cp -ar $t $_outpath && echo "$t format installed"
    done

    runHook postInstall
  '';

  dontFixup = true;

  meta = with lib; {
    description = "Various data formats for the SPDX License List";
    homepage = "https://github.com/spdx/license-list-data";
    license = licenses.cc0;
    maintainers = with maintainers; [ oxzi c0bw3b ];
    platforms = platforms.all;
  };
}
