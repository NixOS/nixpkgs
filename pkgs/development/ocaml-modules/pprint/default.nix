{ lib, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
  pname = "pprint";
  version = "20200410";

  src = fetchFromGitHub {
    owner = "fpottier";
    repo = "pprint";
    rev = version;
    sha256 = "sha256-VXYe4LTb6A4uRKTTG9glnkUEWotwuaRzTj5IT1oGrJs=";
  };

  useDune2 = true;

  meta = with lib; {
    description = "An OCaml adaptation of Wadler’s and Leijen’s prettier printer";
    homepage = "http://gallium.inria.fr/~fpottier/pprint/";
    downloadPage = "https://github.com/fpottier/pprint";
    license = licenses.cecill-c;
    maintainers = with maintainers; [ vbgl ];
  };
}
