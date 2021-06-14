{ stdenv, lib, fetchFromGitHub, pkg-config, libffi, python3, readline }:

stdenv.mkDerivation rec {
  pname = "micropython";
  version = "1.15";

  src = fetchFromGitHub {
    owner  = "micropython";
    repo   = "micropython";
    rev    = "v${version}";
    sha256 = "11bf1lq4kgfs1nzg5cnshh2dqxyk5w2k816i04innri6fj0g7y6p";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ libffi readline ];

  doCheck = true;

  buildPhase = ''
    make -C mpy-cross
    make -C ports/unix
  '';

  checkPhase = ''
    pushd tests
    MICROPY_MICROPYTHON=../ports/unix/micropython ${python3.interpreter} ./run-tests.py
    popd
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 ports/unix/micropython -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "A lean and efficient Python implementation for microcontrollers and constrained systems";
    homepage = "https://micropython.org";
    platforms = [ "x86_64-linux" ];
    license = licenses.mit;
    maintainers = with maintainers; [ sgo ];
  };
}
