{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libfyaml";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "pantoniou";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-b/jRKe23NIVSydoczI+Ax2VjBJLfAEwF8SW61vIDTwA=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  outputs = [ "bin" "dev" "out" "man" ];

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
