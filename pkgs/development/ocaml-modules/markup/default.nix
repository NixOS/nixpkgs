{ lib, buildDunePackage, fetchzip, uutf }:

buildDunePackage rec {
  pname = "markup";
  version = "0.8.2";

  src = fetchzip {
    url = "https://github.com/aantron/markup.ml/archive/${version}.tar.gz";
    sha256 = "13zcrwzjmifniv3bvjbkd2ah8wwa3ld75bxh1d8hrzdvfxzh9szn";
    };

  propagatedBuildInputs = [ uutf ];

  meta = with lib; {
    homepage = "https://github.com/aantron/markup.ml/";
    description = "A pair of best-effort parsers implementing the HTML5 and XML specifications";
    license = licenses.mit;
    maintainers = with maintainers; [
      gal_bolle
      ];
  };

}
