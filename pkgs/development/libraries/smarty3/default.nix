{ stdenv, fetchFromGitHub, ... }: stdenv.mkDerivation rec {
  name = "smarty3-${version}";
  version = "3.1.32";

  src = fetchFromGitHub {
    owner = "smarty-php";
    repo = "smarty";
    rev = "v${version}";
    sha256 = "1rfa5pzr23db1bivpivljgmgpn99m6ksgli64kmii5cmpvxi00y2";
  };

  installPhase = ''
    mkdir $out
    cp -r libs/* $out
  '';

  meta = with stdenv.lib; {
    description = "Smarty 3 template engine";
    longDescription = ''
      Smarty is a template engine for PHP, facilitating the
      separation of presentation (HTML/CSS) from application
      logic. This implies that PHP code is application
      logic, and is separated from the presentation.
    '';
    homepage = https://www.smarty.net;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ das_j ];
  };
}
