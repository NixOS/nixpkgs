{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "cjson";
  version = "1.7.16";

  src = fetchFromGitHub {
    owner = "DaveGamble";
    repo = "cJSON";
    rev = "v${version}";
    sha256 = "sha256-sdhnDpaAO9Fau4uMzNXrbOJ2k0b8+MdhKh6rpFMUwaQ=";
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
