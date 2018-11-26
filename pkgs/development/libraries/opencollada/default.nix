{ lib, stdenv, fetchFromGitHub, cmake, pkgconfig, libxml2, pcre
, darwin}:

stdenv.mkDerivation rec {
  name = "opencollada-${version}";

  version = "1.6.67";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCOLLADA";
    rev = "v${version}";
    sha256 = "0x1h2ns0y05bdvn3i5s600jz6nb8qw8qqgg54njz7833bcy913mj";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ AGL ]);

  propagatedBuildInputs = [ libxml2 pcre ];

  enableParallelBuilding = true;

  patchPhase = ''
    patch -p1 < ${./pcre.patch}
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace GeneratedSaxParser/src/GeneratedSaxParserUtils.cpp \
      --replace math.h cmath
  '';

  meta = {
    description = "A library for handling the COLLADA file format";
    homepage = https://github.com/KhronosGroup/OpenCOLLADA/;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.mit;
  };
}
