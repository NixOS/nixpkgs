{ lib
, stdenv
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, python
, boost
, cppunit
, logLib
, osmosdr
, gmp
, mpir
, fftwFloat
, icu
, gnuradio
, thrift
, gnuradioAtLeast
}:

mkDerivation rec {
  pname = "gr-ais";
  version = "2020-08-13";
  src = fetchFromGitHub {
    owner = "bistromath";
    repo = "gr-ais";
    rev = "2162103226f3dae43c8c2ab23b79483b84346665";
    sha256 = "1vackka34722d8pcspfwj0j6gc9ic7dqq64sgkrpjm94sh3bmb0b";
  };
  disabled = gnuradioAtLeast "3.9";

  nativeBuildInputs = [
    cmake
    pkg-config
    python
  ];

  cmakeFlags = [
    "-DCMAKE_EXE_LINKER_FLAGS=-pthread"
  ];

  buildInputs = [
    cppunit
    osmosdr
    boost
    logLib
    gmp
    mpir
    fftwFloat
    icu
    thrift
    gnuradio.python.pkgs.thrift
  ];

  meta = with lib; {
    description = "Gnuradio block for ais";
    mainProgram = "ais_rx";
    homepage = "https://github.com/bistromath/gr-ais";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    # rpcserver_aggregator.h:111:54: error: no template named 'unary_function'
    # in namespace 'std'; did you mean '__unary_function'?
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ mog ];
  };
}
