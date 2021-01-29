{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libschrift";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "tomolt";
    repo = pname;
    rev = "c207585486b3e78ec5506f55f5d56178f421a53c";
    sha256 = "13qrplsi2a53s84giwnzqmn0zbslyaagvjn89wsn9fd90m2v2bs1";
  };

  postPatch = ''
    substituteInPlace config.mk \
      --replace "PREFIX = /usr/local" "PREFIX = $out"
  '';

  makeFlags = [ "libschrift.a" ];

  meta = with lib; {
    homepage = "https://github.com/tomolt/libschrift";
    description = "A lightweight TrueType font rendering library";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = [ maintainers.sternenseemann ];
  };
}
