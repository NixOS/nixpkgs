{ stdenv, fetchFromGitHub, autoconf, automake, libtool, opencl-headers, ruby }:

stdenv.mkDerivation rec {
  name = "ocl-icd-${version}";
  version = "2.2.12";

  src = fetchFromGitHub {
    owner = "OCL-dev";
    repo = "ocl-icd";
    # Only doc changes since release version
    rev = "b5880e5cfcedfb104681790d3f43d141845d8e36";
    sha256 = "18wpqm28c094c1pgizvnf5nw59s722nlkr775hqjvr1hlnynlkmd";
  };

  nativeBuildInputs = [ autoconf automake libtool ruby ];

  buildInputs = [ opencl-headers ];

  preConfigure = "./bootstrap";

  meta = with stdenv.lib; {
    description = "OpenCL ICD Loader for ${opencl-headers.name}";
    homepage    = "https://github.com/OCL-dev/ocl-icd";
    license     = licenses.bsd2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ gloaming ];
  };
}
