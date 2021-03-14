{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libfyaml";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "pantoniou";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b1wnalh49rbjykw4bj5k3y1d9yr8k6f0im221bl1gyrwlgw7hp5";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  postPatch = ''
    echo ${version} > .tarball-version
  '';

  meta = with lib; {
    homepage = "https://github.com/pantoniou/libfyaml";
    description = "Fully feature complete YAML parser and emitter, supporting the latest YAML spec and passing the full YAML testsuite";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
