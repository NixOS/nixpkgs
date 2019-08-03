{ stdenv, fetchFromGitHub, cmake, libminc, bicpl, arguments, pcre-cpp }:

stdenv.mkDerivation rec {
  pname = "oobicpl";
  name  = "${pname}-2016-03-02";

  owner = "BIC-MNI";

  src = fetchFromGitHub {
    inherit owner;
    repo   = pname;
    rev    = "bc062a65dead2e58461f5afb37abedfa6173f10c";
    sha256 = "05l4ml9djw17bgdnrldhcxydrzkr2f2scqlyak52ph5azj5n4zsx";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libminc bicpl arguments pcre-cpp ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib"
                 "-DBICPL_DIR=${bicpl}/lib"
                 "-DARGUMENTS_DIR=${arguments}/lib"
                 "-DOOBICPL_BUILD_SHARED_LIBS=TRUE" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/${owner}/${pname}";
    description = "Brain Imaging Centre object-oriented programming library (and tools)";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license   = licenses.free;
  };
}
