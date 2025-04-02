{
  stdenv,
  lib,
  gnat,
  gprbuild,
  fetchFromGitHub,
  which,
}:

stdenv.mkDerivation rec {
  pname = "gnatcoll-core";
  version = "24.0.0";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "gnatcoll-core";
    rev = "v${version}";
    sha256 = "1cks2w0inj9hvamsdxjriwxnx1igmx2khhr6kwxshsl30rs8nzvb";
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
