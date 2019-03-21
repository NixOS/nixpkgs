{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "arguments";
  name  = "${pname}-2015-11-30";

  owner = "BIC-MNI";

  src = fetchFromGitHub {
    inherit owner;
    repo   = pname;
    rev    = "b3aad97f6b6892cb8733455d0d448649a48fa108";
    sha256 = "1ar8lm1w1jflz3vdmjr5c4x6y7rscvrj78b8gmrv79y95qrgzv6s";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ];

  #cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib" "-DBICPL_DIR=${bicpl}/lib" "-DBUILD_TESTING=FALSE" ];

  doCheck = false;
  # internal_volume_io.h: No such file or directory

  meta = with stdenv.lib; {
    homepage = "https://github.com/${owner}/${pname}";
    description = "Library for argument handling for MINC programs";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license   = licenses.free;
  };
}
