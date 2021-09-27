{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "openfec";
  version = "1.4.2.4";

  src = fetchFromGitHub {
    owner = "roc-streaming";
    repo = "openfec";
    rev = "v${version}";
    sha256 = "0aj0dabqymf9rxqir21jsk8n2rhfwywqiwwafyw3dq2123xapim3";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DDEBUG:STRING=OFF"
  ];

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include
    cp -d ../bin/Release/eperftool \
      ../bin/Release/simple_client \
      ../bin/Release/simple_server \
      ../bin/Release/test_code_params \
      ../bin/Release/test_create_instance \
      ../bin/Release/test_encoder_instance \
      $out/bin
    cp -d ../bin/Release/libopenfec.so \
      ../bin/Release/libopenfec.so.1 \
      ../bin/Release/libopenfec.so.1.4.2 \
      $out/lib
    cp -R -d ../src $out/include/openfec
  '';

  meta = with lib; {
    description = "Application-level Forward Erasure Correction codes";
    homepage = "https://github.com/roc-streaming/openfec";
    license = licenses.cecill-c;
    maintainers = with maintainers; [ iclanzan ];
    platforms = platforms.unix;
  };
}
