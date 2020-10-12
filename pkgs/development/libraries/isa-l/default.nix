{ stdenv, fetchFromGitHub, nasm }:

stdenv.mkDerivation rec {
  pname = "isa-l";
  version = "2.29.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "isa-l";
    rev = "v${version}";
    sha256 = "1sfk7942b2i00bfhlh6ddx2dl76wss0k8gm6v5rqcrzrs3z01pc8";
  };

  nativeBuildInputs = [ nasm ];
  makeFlags = [
    "-f" "Makefile.unx"
    "prefix=$(out)"
  ];

  meta = with stdenv.lib; {
    description = "Intel(R) Intelligent Storage Acceleration Library";
    homepage = "https://github.com/intel/isa-l";
    license = licenses.bsd3;
    maintainers = [ maintainers.volth ];
    platforms = platforms.linux;
  };
}
