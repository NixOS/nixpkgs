{ stdenv, cmake, fetchFromGitHub, bctoolbox }:

stdenv.mkDerivation rec {
  baseName = "belr";
  version = "0.1.3";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = "${baseName}";
    rev = "${version}";
    sha256 = "0mf8lsyq1z3b5p47c00lnwc8n7v9nzs1fd2g9c9hnz6fjd2ka44w";
  };

  buildInputs = [ bctoolbox ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib;{
    description = "Belr is Belledonne Communications' language recognition library";
    homepage = https://github.com/BelledonneCommunications/belr;
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
