{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "cjson";
  version = "1.7.14";

  src = fetchFromGitHub {
    owner = "DaveGamble";
    repo = "cJSON";
    rev = "v${version}";
    sha256 = "1a3i9ydl65dgwgmlg79n5q8qilmjkaakq56sam1w25zcrd8jy11q";
  };

  nativeBuildInputs = [ cmake ];

  # cJSON actually uses C99 standard, not C89
  # https://github.com/DaveGamble/cJSON/issues/275
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace -std=c89 -std=c99
  '';

  meta = with lib; {
    homepage = "https://github.com/DaveGamble/cJSON";
    description = "Ultralightweight JSON parser in ANSI C";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
  };
}
