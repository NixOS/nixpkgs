{ stdenv
, lib
, fetchFromGitHub
, gnat
# use gprbuild-boot since gprbuild proper depends
# on this xmlada derivation.
, gprbuild-boot
}:

stdenv.mkDerivation rec {
  pname = "xmlada";
  version = "22.0.0";

  src = fetchFromGitHub {
    name = "xmlada-${version}-src";
    owner = "AdaCore";
    repo = "xmlada";
    rev = "v${version}";
    sha256 = "1pg6m0sfc1vwvd18r80jv2vwrsb2qgvyl8jmmrmpbdni0npx0kv3";
  };

  nativeBuildInputs = [
    gnat
    gprbuild-boot
  ];

  meta = with lib; {
    description = "XML/Ada: An XML parser for Ada";
    homepage = "https://github.com/AdaCore/xmlada";
    maintainers = [ maintainers.sternenseemann ];
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}

