{ stdenv, buildPythonPackage, fetchFromGitHub, substituteAll, locale, pytest, version ? "7.0" }:

buildPythonPackage rec {
  pname = "click";
  inherit version;

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "click";
    rev = version;
    sha256 = if version == "7.0"
      then "13mpfazsbiwwwma19z473sc92mwrla8rcnhvnb9vsgiyd2pz33g0"  # 7.0
      else "1mhns6c00gnfjzqka995aah0445jzh56mipmypj3xpmrxl3acpq2"; # 6.7
  };

  patches = [(substituteAll {
    src = if stdenv.lib.versionAtLeast version "7.0"
      then ./fix-paths.patch
      else ./fix-paths67.patch;
    locale = "${locale}/bin/locale";
  })];

  buildInputs = [ pytest ];

  checkPhase = ''
    py.test tests
  '';

  # https://github.com/pallets/click/issues/823
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://click.pocoo.org/;
    description = "Create beautiful command line interfaces in Python";
    longDescription = ''
      A Python package for creating beautiful command line interfaces in a
      composable way, with as little code as necessary.
    '';
    license = licenses.bsd3;
  };
}
