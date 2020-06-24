{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "TT2020";
  version = "2020-01-05";

  src = fetchFromGitHub {
    owner = "ctrlcctrlv";
    repo = pname;
    rev = "2b418fab5f99f72a18b3b2e7e2745ac4e03aa612";
    sha256 = "1amaps1clq6qb70a7c11y01bgvgzjvjda5vjqh1cv98dgqpdzjj8";
  };

  meta = with lib; {
    description = "An advanced, open source, hyperrealistic, multilingual typewriter font for a new decade";
    homepage = "https://ctrlcctrlv.github.io/TT2020";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ sikmir ];
  };
}
