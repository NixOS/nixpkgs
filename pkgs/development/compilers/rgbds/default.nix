{stdenv, lib, fetchFromGitHub, yacc, flex, pkgconfig, libpng}:

stdenv.mkDerivation rec {
  name = "rgbds-${version}";
  version = "0.3.2";
  src = fetchFromGitHub {
    owner = "bentley";
    repo = "rgbds";
    rev = "v${version}";
    sha256 = "034l1xqp46h7yjgbvszyky2gmvyy8cq1fcqsnj9c92mbsv81g9qh";
  };

  buildInputs = [ libpng ];
  nativeBuildInputs = [ yacc flex pkgconfig ];
  installFlags = "PREFIX=\${out}";

  meta = with lib; {
    homepage = https://www.anjbe.name/rgbds/;
    description = "An assembler/linker package that produces Game Boy programs";
    license = licenses.free;
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.all;
  };
}
