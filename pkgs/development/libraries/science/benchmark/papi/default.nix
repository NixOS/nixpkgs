{ stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  version = "5.6.0";
  name = "papi-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/icl/papi/get/papi-5-6-0-t.tar.gz";
    sha256 = "13mngf9kl0y2wfxqvkad0smdaag7k8fvw82b4312gx62nwhc1i6r";
  };

  buildInputs = [ stdenv ];

  preConfigure = ''
    cd src
  '';

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    homepage = https://icl.utk.edu/papi/;
    description = "PAPI provides the tool designer and application engineer with a consistent interface and methodology for use of the performance counter hardware found in most major microprocessors";
    license = licenses.bsdOriginal;
    platforms = platforms.linux;
    maintainers = [ maintainers.costrouc ];
  };
}
