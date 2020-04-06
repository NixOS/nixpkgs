{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "jsonnet";
  version = "0.15.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "google";
    repo = "jsonnet";
    sha256 = "06imnpbc5mn1dis051f54q6nq80dbm51nhxmba61rdyhf1131ml8";
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
