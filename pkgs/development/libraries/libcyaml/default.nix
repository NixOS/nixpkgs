{ stdenv, lib, fetchFromGitHub
, libyaml
}:

stdenv.mkDerivation rec {
  pname = "libcyaml";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "tlsa";
    repo = "libcyaml";
    rev = "v${version}";
    sha256 = "sha256-ntgTgIJ3u1IbR/eYOgwmgR9Jvx28P+l44wAMlBEcbj8=";
  };

  buildInputs = [ libyaml ];

  makeFlags = [ "VARIANT=release" "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/tlsa/libcyaml";
    description = "C library for reading and writing YAML";
    changelog = "https://github.com/tlsa/libcyaml/raw/v${version}/CHANGES.md";
    license = licenses.isc;
    platforms = platforms.unix;
  };
}
