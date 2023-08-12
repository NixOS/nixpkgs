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
  version = "23.0.0";

  src = fetchFromGitHub {
    name = "xmlada-${version}-src";
    owner = "AdaCore";
    repo = "xmlada";
    rev = "v${version}";
    sha256 = "sha256-covcSwlQQjRKTv0DdMEgahXXlch0TeKnvSyOsGO9+e0=";
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

