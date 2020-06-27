{ lib, mkFont, fetchFromGitHub }:

mkFont {
  pname = "myrica";
  version = "2.011.20160403";

  src = fetchFromGitHub {
    owner = "tomokuni";
    repo = "Myrica";
    rev = "b737107723bfddd917210f979ccc32ab3eb6dc20";
    sha256 = "0p95kanf1682d9idq4v9agxlvxh08vhvfid2sjyc63knndsrl7wk";
  };

  meta = with lib; {
    homepage = "https://myrica.estable.jp/";
    license = licenses.ofl;
    maintainers = with maintainers; [ mikoim ];
    platforms = platforms.all;
  };
}
