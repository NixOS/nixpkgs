{
  fetchFromGitHub,
  lib,
  stdenv,
  which,
  autoconf,
  automake,
  libtool,
}:
stdenv.mkDerivation rec {
  pname = "crcutil";
  version = "8678969f02c4679fa40abaa9c5d7afadec50ed84";

  src = fetchFromGitHub {
    owner = "cloudera";
    repo = "crcutil";
    rev = version;
    hash = "sha256:1890pksyszwxhpy9n1wh5bmrakbgrhsf7piwzgkj0206b58a2k73";
  };

  nativeBuildInputs = [
    which
    autoconf
    automake
    libtool
  ];

  NIX_CFLAGS_COMPILE = "-mcrc32";

  preConfigurePhases = "autogen";
  autogen = ''
    bash ./autogen.sh
  '';

  meta = {
    homepage = "https://github.com/cloudera/crcutil";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kevincox ];
    description = "High performance CRC implementation.";
  };
}
