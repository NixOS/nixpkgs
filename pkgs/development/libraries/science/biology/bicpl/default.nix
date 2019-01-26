{ stdenv, fetchFromGitHub, cmake, libminc, netpbm }:

stdenv.mkDerivation rec {
  pname = "bicpl";
  name  = "${pname}-2017-09-10";

  owner = "BIC-MNI";

  # current master is significantly ahead of most recent release, so use Git version:
  src = fetchFromGitHub {
    inherit owner;
    repo   = pname;
    rev    = "612a63e740fadb162fcf27ee00da6a18dec4d5a9";
    sha256 = "1vv9gi184bkvp3f99v9xmmw1ly63ip5b09y7zdjn39g7kmwzrga7";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libminc netpbm ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib" "-DBUILD_TESTING=FALSE" ];

  doCheck = false;
  # internal_volume_io.h: No such file or directory

  meta = with stdenv.lib; {
    homepage = "https://github.com/${owner}/${pname}";
    description = "Brain Imaging Centre programming library";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license   = licenses.free;
  };
}
