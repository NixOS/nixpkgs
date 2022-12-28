{ stdenv, lib, fetchFromGitHub, libtool, automake, autoconf, ucx
, enableCuda ? false
, cudatoolkit
, enableAvx ? stdenv.hostPlatform.avxSupport
, enableSse41 ? stdenv.hostPlatform.sse4_1Support
, enableSse42 ? stdenv.hostPlatform.sse4_2Support
} :

stdenv.mkDerivation rec {
  pname = "ucc";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucc";
    rev = "v${version}";
    sha256 = "sha256-5rf08SXy+vCfnz4zLJ0cMnxwso4WpZOt0jRRAUviVFU=";
  };

  enableParallelBuilding = true;

  postPatch = ''

    for comp in $(find src/components -name Makefile.am); do
      substituteInPlace $comp \
        --replace "/bin/bash" "${stdenv.shell}"
    done
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  nativeBuildInputs = [ libtool automake autoconf ];
  buildInputs = [ ucx ]
    ++ lib.optional enableCuda cudatoolkit;

  configureFlags = [ ]
   ++ lib.optional enableSse41 "--with-sse41"
   ++ lib.optional enableSse42 "--with-sse42"
   ++ lib.optional enableAvx "--with-avx"
   ++ lib.optional enableCuda "--with-cuda=${cudatoolkit}";

  meta = with lib; {
    description = "Collective communication operations API";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
