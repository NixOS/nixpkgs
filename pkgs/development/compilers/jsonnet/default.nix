{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "jsonnet";
  version = "0.13.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "google";
    repo = "jsonnet";
    sha256 = "1fibr1kysbxcf8jp2a4xvs3n7i8d9k2430agxzc9mdyqrh79zlxk";
  };

  enableParallelBuilding = true;

  makeFlags = [
    "jsonnet"
    "jsonnetfmt"
    "libjsonnet.so"
  ];

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include
    cp jsonnet $out/bin/
    cp jsonnetfmt $out/bin/
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
