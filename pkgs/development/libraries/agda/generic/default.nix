{
  lib,
  mkDerivation,
  fetchFromGitHub,
  standard-library,
}:

mkDerivation rec {
  pname = "generic";
  version = "0.1.0.2";

  src = fetchFromGitHub {
    owner = "effectfully";
    repo = "Generic";
    rev = "v${version}";
    sha256 = "05igsd2gaj6h9bkqwp8llhvn4qvc5gmi03x4fnz096ba8m6x8s3n";
  };

  buildInputs = [
    standard-library
  ];

  preBuild = ''
    echo "module Everything where" > Everything.agda
    find src -name '*.agda' | sed -e 's/src\///;s/\//./g;s/\.agda$//;s/^/import /' >> Everything.agda
  '';

  meta = with lib; {
    # Remove if a version compatible with agda 2.6.2 is made
    broken = true;
    description = "A library for doing generic programming in Agda";
    homepage = src.meta.homepage;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      alexarice
      turion
    ];
  };
}
