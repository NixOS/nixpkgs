{ stdenv
, lib
, gnat
, gprbuild
, fetchFromGitHub
, xmlada
, which
}:

stdenv.mkDerivation rec {
  pname = "gnatcoll-core";
  version = "23.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "gnatcoll-core";
    rev = "v${version}";
    sha256 = "11q66xszqvpc9jyyzivcakik27d23yniahjdznb47wyqkxphm1dl";
  };

  nativeBuildInputs = [
    gprbuild
    which
    gnat
  ];

  # propagate since gprbuild needs to find
  # referenced GPR project definitions
  propagatedBuildInputs = [
    gprbuild # libgpr
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "PROCESSORS=$(NIX_BUILD_CORES)"
    # confusingly, for gprbuild --target is autoconf --host
    "TARGET=${stdenv.hostPlatform.config}"
  ];

  meta = with lib; {
    homepage = "https://github.com/AdaCore/gnatcoll-core";
    description = "GNAT Components Collection - Core packages";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.all;
  };
}
