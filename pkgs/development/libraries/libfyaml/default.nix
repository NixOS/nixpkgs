{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libfyaml";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "pantoniou";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RxaeDtsdPtcTYJ7qMVmBCm1TsMI7YsXCz2w/Bq2RmaA=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  doCheck = true;

  preCheck = ''
    patchShebangs test
  '';

  meta = with lib; {
    homepage = "https://github.com/pantoniou/libfyaml";
    description = "Fully feature complete YAML parser and emitter, supporting the latest YAML spec and passing the full YAML testsuite";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
