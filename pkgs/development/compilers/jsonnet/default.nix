{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "jsonnet-${version}";
  version = "0.12.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "google";
    repo = "jsonnet";
    sha256 = "13a0sf1k8ivxhc28w0d0axzr0sj3jccl9sjq6l0dkyzrnmbxzmkb";
  };

  enableParallelBuilding = true;

  makeFlags = [
    "jsonnet"
    "libjsonnet.so"
  ];

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include
    cp jsonnet $out/bin/
    cp libjsonnet*.so $out/lib/
    cp -a include/*.h $out/include/
  '';

  meta = {
    description = "Purely-functional configuration language that helps you define JSON data";
    maintainers = with lib.maintainers; [ benley copumpkin ];
    license = lib.licenses.asl20;
    homepage = https://github.com/google/jsonnet;
    platforms = lib.platforms.unix;
  };
}
