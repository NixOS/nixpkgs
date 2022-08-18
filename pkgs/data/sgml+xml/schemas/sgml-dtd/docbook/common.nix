{ stdenv
, lib
, fetchurl
, unzip

, version
, src
}:

let
  isoents = fetchurl {
    url = "https://web.archive.org/web/20220713122518/http://xml.coverpages.org/ISOEnts.zip";
    sha256 = "1clrkaqnvc1ja4lj8blr0rdlphngkcda3snm7b9jzvcn76d3br6w";
  };
in

stdenv.mkDerivation {
  pname = "docbook-sgml";
  inherit version;

  nativeBuildInputs = [
    unzip
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    o=$out/sgml/dtd/docbook-${version}
    mkdir -p "$o"
    cd "$o"
    unzip "${src}"
    unzip "${isoents}"
    sed -e "s/iso-/ISO/" -e "s/.gml//" -i docbook.cat

    runHook postInstall
  '';

  meta = {
    description = "DTD schemas for SGML variant of DocBook ${version}";
    license = lib.licenses.free;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
