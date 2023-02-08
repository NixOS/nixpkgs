{ stdenv, lib, fetchzip, cmake }:

stdenv.mkDerivation rec {
  pname = "openfec";
  version = "1.4.2";

  src = fetchzip {
    url = "http://openfec.org/files/openfec_v1_4_2.tgz";
    sha256 = "sha256:0c2lg8afr7lqpzrsi0g44a6h6s7nq4vz7yc9vm2k57ph2y6r86la";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [ "-DDEBUG:STRING=OFF" ];

  installPhase =
    let so = stdenv.hostPlatform.extensions.sharedLibrary;
    in ''
      # This is pretty horrible but sadly there is not installation procedure
      # provided.
      mkdir -p $dev/include
      cp -R ../src/* $dev/include
      find $dev/include -type f -a ! -iname '*.h' -delete

      install -D -m755 -t $out/lib ../bin/Release/libopenfec${so}
    '' + lib.optionalString stdenv.isDarwin ''
      install_name_tool -id $out/lib/libopenfec${so} $out/lib/libopenfec${so}
    '' + ''
      ln -s libopenfec${so} $out/lib/libopenfec${so}.1
    '';

  meta = with lib; {
    description = "Application-level Forward Erasure Correction codes";
    homepage = "https://github.com/roc-streaming/openfec";
    license = licenses.cecill-c;
    maintainers = with maintainers; [ bgamari ];
    platforms = platforms.unix;
  };
}
