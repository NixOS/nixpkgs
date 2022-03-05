{ lib, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  pname = "smarty3";
  version = "3.1.44";

  src = fetchFromGitHub {
    owner = "smarty-php";
    repo = "smarty";
    rev = "v${version}";
    sha256 = "sha256-9a9OC18jyFpmFXffYOYHZ0j01j4NCF5zwrSYr1fZwqo=";
  };

  installPhase = ''
    mkdir $out
    cp -r libs/* $out
  '';

  meta = with lib; {
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
