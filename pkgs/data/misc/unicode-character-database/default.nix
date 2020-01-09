{ stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "unicode-character-database";
  version = "12.1.0";

  src = fetchurl {
    url = "https://www.unicode.org/Public/zipped/${version}/UCD.zip";
    sha256 = "19m06iw0jl7lhlggcmghi12p6jld0qrmfpksgc243yn6sjh53fi5";
  };

  nativeBuildInputs = [
    unzip
  ];

  setSourceRoot = ''
    sourceRoot=$PWD
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/unicode
    cp -r * $out/share/unicode

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Unicode Character Database";
    homepage = "https://www.unicode.org/";
    license = licenses.free; # https://www.unicode.org/license.html
    platforms = platforms.all;
  };
}
