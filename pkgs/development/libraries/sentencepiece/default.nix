{ stdenv
, fetchFromGitHub
, cmake
, gperftools

, enableStatic ? false
, withGPerfTools ? true
}:

stdenv.mkDerivation rec {
  pname = "sentencepiece";
  version = "0.1.91";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "1yg55h240iigjaii0k70mjb4sh3mgg54rp2sz8bx5glnsjwys5s3";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = stdenv.lib.optional withGPerfTools gperftools;

  cmakeFlags = [
    "-DSPM_ENABLE_SHARED=${if enableStatic then "OFF" else "ON"}"
  ];

  postInstall = stdenv.lib.optionalString (!enableStatic) ''
    rm $out/lib/*.a
  '';

  outputs = [ "bin" "dev" "out" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/google/sentencepiece";
    description = "Unsupervised text tokenizer for Neural Network-based text generation";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ danieldk pashashocky ];
  };
}
