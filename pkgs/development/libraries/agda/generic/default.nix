{ lib, mkDerivation, fetchFromGitHub, standard-library }:

mkDerivation rec {
  pname = "generic";
  version = "0.1";

  src = fetchFromGitHub {
    repo = "Generic";
    owner = "effectfully";
    rev = "v${version}";
    sha256 = "121121rg3daaqp91845fbyws6g28hyj1ywmh12n54r3nicb35g5q";
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
