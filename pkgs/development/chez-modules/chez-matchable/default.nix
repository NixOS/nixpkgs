{ stdenv, fetchgit, chez }:

stdenv.mkDerivation {
  pname = "chez-matchable";
  version = "1.0";

  src = fetchgit {
    url = "https://github.com/fedeinthemix/chez-matchable.git";
    rev = "73e46432ae70ec72eba6ef116bd84ad9ee38b2f2";
    sha256 = "0rvb177m3vfq625nj7dawgm323jvx3in3nq6xdw8z4psn3bn1ag9";
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
