{ lib, stdenv, fetchFromGitLab, fetchurl, autoconf-archive, autoreconfHook, pkg-config, python3 }:
let
  chromium_version = "90.0.4417.1";

  hsts_list = fetchurl {
    url = "https://raw.github.com/chromium/chromium/${chromium_version}/net/http/transport_security_state_static.json";
    sha256 = "09f24n30x5dmqk8zk7k2glcilgr27832a3304wj1yp97158sqsfx";
  };

in
stdenv.mkDerivation rec {
  pname = "libhsts";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "rockdaboot";
    repo = pname;
    rev = "libhsts-${version}";
    sha256 = "0gbchzf0f4xzb6zjc56dk74hqrmdgyirmgxvvsqp9vqn9wb5kkx4";
  };

  postPatch = ''
    pushd tests
    cp ${hsts_list} transport_security_state_static.json
    sed 's/^ *\/\/.*$//g' transport_security_state_static.json >hsts.json
    popd
    patchShebangs src/hsts-make-dafsa
  '';

  nativeBuildInputs = [ autoconf-archive autoreconfHook pkg-config python3 ];

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Library to easily check a domain against the Chromium HSTS Preload list";
    mainProgram = "hsts";
    homepage = "https://gitlab.com/rockdaboot/libhsts";
    license = with licenses; [ mit bsd3 ];
    maintainers = with maintainers; [ ];
  };
}
