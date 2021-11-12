{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libfyaml";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "pantoniou";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wq7ah9a83w0c5qppdpwqqjffwi85q7slz4im0kmkhxdp23v9m1i";
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
