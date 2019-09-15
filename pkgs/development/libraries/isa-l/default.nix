{ stdenv, fetchFromGitHub, yasm }:

stdenv.mkDerivation rec {
  pname = "isa-l";
  version = "2.27.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "isa-l";
    rev = "v${version}";
    sha256 = "15578isyinikw0ypfrag27ccipcl3djbgfqhidjn11r93pwb5r7z";
  };

  nativeBuildInputs = [ yasm ];
  configurePhase = "cp Makefile.unx Makefile";
  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "Intel(R) Intelligent Storage Acceleration Library";
    homepage = https://github.com/intel/isa-l;
    license = licenses.bsd3;
    maintainers = [ maintainers.volth ];
    platforms = [ "x86_64-linux" ];
  };
}
