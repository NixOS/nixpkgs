{ stdenv, fetchFromGitHub, nasm }:

stdenv.mkDerivation rec {
  pname = "isa-l";
  version = "2.28.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "isa-l";
    rev = "v${version}";
    sha256 = "0zswmyi3r7i7n1k0s3jkkmd3xgjpd5chnqf2ffmz3zk46w8imj15";
  };

  nativeBuildInputs = [ nasm ];
  configurePhase = "cp Makefile.unx Makefile";
  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "Intel(R) Intelligent Storage Acceleration Library";
    homepage = https://github.com/intel/isa-l;
    license = licenses.bsd3;
    maintainers = [ maintainers.volth ];
    platforms = platforms.linux;
  };
}
