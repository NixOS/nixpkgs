# set VAMP_PATH ?
# plugins availible on sourceforge and http://www.vamp-plugins.org/download.html (various licenses)

{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libsndfile,
}:

stdenv.mkDerivation rec {
  pname = "vamp-plugin-sdk";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "vamp-plugins";
    repo = "vamp-plugin-sdk";
    rev = "vamp-plugin-sdk-v${version}";
    hash = "sha256-5jNA6WmeIOVjkEMZXB5ijxyfJT88alVndBif6dnUFdI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsndfile ];

  enableParallelBuilding = true;
  makeFlags = [
    "AR:=$(AR)"
    "RANLIB:=$(RANLIB)"
  ] ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "-o test";

  meta = with lib; {
    description = "Audio processing plugin system for plugins that extract descriptive information from audio data";
    homepage = "https://vamp-plugins.org/";
    license = licenses.bsd3;
    maintainers = [
      maintainers.goibhniu
      maintainers.marcweber
    ];
    platforms = platforms.unix;
  };
}
