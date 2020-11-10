{ lib, mkDerivation, fetchFromGitHub, standard-library }:

mkDerivation rec {
  pname = "generic";
  version = "0.1.0.1";

  src = fetchFromGitHub {
    repo = "Generic";
    owner = "effectfully";
    rev = "v${version}";
    sha256 = "07l44yzx1jly20kmkmkjk8q493bn6x7i3xxpz6mhadkqlxyhmc8s";
  };

  buildInputs = [
    standard-library
  ];

  preBuild = ''
    echo "module Everything where" > Everything.agda
    find src -name '*.agda' | sed -e 's/src\///;s/\//./g;s/\.agda$//;s/^/import /' >> Everything.agda
  '';

  meta = with lib; {
    description =
      "A library for doing generic programming in Agda";
    homepage = src.meta.homepage;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ alexarice turion ];
  };
}
