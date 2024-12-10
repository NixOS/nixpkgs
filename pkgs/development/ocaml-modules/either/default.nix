{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "either";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/either/releases/download/${version}/either-${version}.tbz";
    sha256 = "bf674de3312dee7b7215f07df1e8a96eb3d679164b8a918cdd95b8d97e505884";
  };

  useDune2 = true;

  meta = with lib; {
    description = "Compatibility Either module";
    license = licenses.mit;
    homepage = "https://github.com/mirage/either";
    maintainers = [ maintainers.sternenseemann ];
  };
}
