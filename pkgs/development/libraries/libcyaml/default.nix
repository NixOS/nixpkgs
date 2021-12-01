{ stdenv, lib, fetchFromGitHub
, libyaml
}:

stdenv.mkDerivation rec {
  pname = "libcyaml";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "tlsa";
    repo = "libcyaml";
    rev = "v${version}";
    sha256 = "sha256-u5yLrAXaavALNArj6yw+v5Yn4eqXWTHmUxHe+pVCbXM=";
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
