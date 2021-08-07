{ stdenv, lib, fetchFromGitHub
, libyaml
}:

stdenv.mkDerivation rec {
  pname = "libcyaml";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "tlsa";
    repo = "libcyaml";
    rev = "v${version}";
    sha256 = "sha256-LtU1r95YoLuQ2JCphxbMojxKyXnt50XEARGUPftLgsU=";
  };

  buildInputs = [ libyaml ];

  makeFlags = [ "VARIANT=release" "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/tlsa/libcyaml";
    description = "C library for reading and writing YAML";
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
