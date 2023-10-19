{ stdenv, lib, fetchFromGitHub, libtool, automake, autoconf, ucx
, config
, enableCuda ? config.cudaSupport
, cudatoolkit
, enableAvx ? stdenv.hostPlatform.avxSupport
, enableSse41 ? stdenv.hostPlatform.sse4_1Support
, enableSse42 ? stdenv.hostPlatform.sse4_2Support
} :

stdenv.mkDerivation rec {
  pname = "ucc";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "openucx";
    repo = "ucc";
    rev = "v${version}";
    sha256 = "sha256-7Mo9zU0sogGyDdWIfTgUPoR5Z8D722asC2y7sHnKbzs=";
  };

  outputs = [ "out" "dev" ];

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

  postInstall = ''
    find $out/lib/ -name "*.la" -exec rm -f \{} \;

    moveToOutput bin/ucc_info $dev
  '';

  meta = with lib; {
    description = "Collective communication operations API";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
