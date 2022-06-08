{ stdenv
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "exprtk";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "ArashPartow";
    repo = "exprtk";
    rev = version;
    sha256 = "5/k+y3gNJeggfwXmtAVqmaiV+BXX+WKtWwZWcQSrQDM=";
  };

  # There are just extremely-slow-to-build examples and benchmarks.
  dontBuild = true;

  # No install target.
  installPhase = ''
    runHook preInstall

    install -Dt "$out/include" exprtk.hpp

    runHook postInstall
  '';

  meta = with lib; {
    description = "C++ Mathematical Expression Parsing And Evaluation Library";
    homepage = "https://www.partow.net/programming/exprtk/index.html";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}
