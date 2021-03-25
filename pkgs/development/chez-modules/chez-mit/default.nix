{ stdenv, lib, fetchgit, chez, chez-srfi }:

stdenv.mkDerivation {
  pname = "chez-mit";
  version = "1.0";

  src = fetchgit {
    url = "https://github.com/fedeinthemix/chez-mit.git";
    rev = "68f3d7562e77f694847dc74dabb5ecbd106cd6be";
    sha256 = "0c7i3b6i90xk96nmxn1pc9272a4yal4v40dm1a4ybdi87x53zkk0";
  };

  buildInputs = [ chez chez-srfi ];

  buildPhase = ''
    make PREFIX=$out CHEZ=${chez}/bin/scheme
  '';

  installPhase = ''
    make install PREFIX=$out CHEZ=${chez}/bin/scheme
  '';

  doCheck = false;

  meta = with lib; {
    description = "This is a MIT/GNU Scheme compatibility library for Chez Scheme";
    homepage = "https://github.com/fedeinthemix/chez-mit/";
    maintainers = [ maintainers.jitwit ];
    license = licenses.free;
  };

}
