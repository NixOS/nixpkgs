{ stdenv, lib, fetchFromGitHub, chez, chez-srfi, chez-mit }:

stdenv.mkDerivation rec {
  pname = "chez-scmutils";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "fedeinthemix";
    repo = "chez-scmutils";
    rev = "v${version}";
    sha256 = "sha256-9GBoHbLNEnPz81s2rBYO3S0bXldetwc8eu9i5CgvYFE=";
  };

  buildInputs = [ chez chez-srfi chez-mit ];

  buildPhase = ''
    make PREFIX=$out CHEZ=${chez}/bin/scheme
  '';

  installPhase = ''
    make install PREFIX=$out CHEZ=${chez}/bin/scheme
  '';

  doCheck = false;

  meta = with lib; {
    description = "This is a port of the ‘MIT Scmutils’ library to Chez Scheme";
    homepage = "https://github.com/fedeinthemix/chez-scmutils/";
    maintainers = [ maintainers.jitwit ];
    license = licenses.gpl3;
  };

}
