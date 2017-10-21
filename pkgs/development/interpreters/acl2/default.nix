{ stdenv, fetchurl, sbcl }:

stdenv.mkDerivation rec {
  name = "acl2-${version}";
  version = "v6-5";

  src = fetchurl {
    url = "http://www.cs.utexas.edu/users/moore/acl2/${version}/distrib/acl2.tar.gz";
    sha256 = "19kfclgpdyms016s06pjf3icj3mx9jlcj8vfgpbx2ac4ls0ir36g";
    name = "acl2-${version}.tar.gz";
  };

  buildInputs = [ sbcl ];

  phases = "unpackPhase installPhase";

  installSuffix = "acl2";

  installPhase = ''
    mkdir -p $out/share/${installSuffix}
    cp -R . $out/share/${installSuffix}
    cd $out/share/${installSuffix}
    make 'LISP=${sbcl}/bin/sbcl --dynamic-space-size 2000'
    make 'LISP=${sbcl}/bin/sbcl --dynamic-space-size 2000' regression
    make LISP=${sbcl}/bin/sbcl TAGS
    mkdir -p $out/bin
    cp saved_acl2 $out/bin/acl2
  '';

  meta = {
    description = "An interpreter and a prover for a Lisp dialect";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
