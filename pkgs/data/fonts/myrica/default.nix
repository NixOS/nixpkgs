{ lib, fetchFromGitHub }:

fetchFromGitHub {
  name = "myrica-2.011.20160403";

  owner = "tomokuni";
  repo = "Myrica";
  # commit does not exist on any branch on the target repository
  rev = "b737107723bfddd917210f979ccc32ab3eb6dc20";
  sha256 = "187rklcibbkai6m08173ca99qn8v7xpdfdv0izpymmavj85axm12";

  postFetch = ''
    tar --strip-components=1 -xzvf $downloadedFile
    mkdir -p $out/share/fonts/truetype
    cp product/*.TTC $out/share/fonts/truetype
  '';

  meta = with lib; {
    homepage = "https://myrica.estable.jp/";
    license = licenses.ofl;
    maintainers = with maintainers; [ mikoim ];
    platforms = platforms.all;
  };
}
