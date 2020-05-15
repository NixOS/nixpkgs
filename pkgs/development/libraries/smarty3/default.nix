{ stdenv, fetchFromGitHub, ... }: stdenv.mkDerivation rec {
  pname = "smarty3";
  version = "3.1.36";

  src = fetchFromGitHub {
    owner = "smarty-php";
    repo = "smarty";
    rev = "v${version}";
    sha256 = "0jljzw1xl2kjwf9cylp1ddnjhz7wbm499s03r479891max1m2mlf";
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
    homepage = "https://www.smarty.net";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ das_j ];
  };
}
