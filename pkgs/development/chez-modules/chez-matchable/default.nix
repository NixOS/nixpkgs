{ stdenv, fetchFromGitHub, chez }:

stdenv.mkDerivation rec {
  pname = "chez-matchable";
  version = "20160306";

  src = fetchFromGitHub {
    owner = "fedeinthemix";
    repo = "chez-matchable";
    rev = "v${version}";
    sha256 = "02qn7x348p23z1x5lwhkyj7i8z6mgwpzpnwr8dyina0yzsdkr71s";
  };

  buildInputs = [ chez ];

  buildPhase = ''
    make PREFIX=$out CHEZ=${chez}/bin/scheme
  '';

  installPhase = ''
    make install PREFIX=$out CHEZ=${chez}/bin/scheme
  '';

  doCheck = false;

  meta = {
    description = "This is a Library for ChezScheme providing the protable hygenic pattern matcher by Alex Shinn";
    homepage = https://github.com/fedeinthemix/chez-matchable/;
    maintainers = [ stdenv.lib.maintainers.jitwit ];
    license = stdenv.lib.licenses.publicDomain;
  };

}
