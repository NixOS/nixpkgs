{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "myrica-${version}";
  version = "2.011.20160403";

  src = fetchFromGitHub {
    owner = "tomokuni";
    repo = "Myrica";
    rev = "b737107723bfddd917210f979ccc32ab3eb6dc20";
    sha256 = "0p95kanf1682d9idq4v9agxlvxh08vhvfid2sjyc63knndsrl7wk";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp $src/product/*.TTC $out/share/fonts/truetype
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "187rklcibbkai6m08173ca99qn8v7xpdfdv0izpymmavj85axm12";

  meta = with stdenv.lib; {
    homepage = https://myrica.estable.jp/;
    license = licenses.ofl;
    maintainers = with maintainers; [ mikoim ];
    platforms = platforms.all;
  };
}
