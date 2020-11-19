{ stdenv, lib, fetchFromGitHub, pkgconfig, libffi, python3, readline }:

stdenv.mkDerivation rec {
  pname = "micropython";
  version = "1.13";

  src = fetchFromGitHub {
    owner  = "micropython";
    repo   = "micropython";
    rev    = "v${version}";
    sha256 = "0m9g6isys4pnlnkdmrw7lxaxdrjn02j481wz5x5cdrmrbi4zi17z";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig python3 ];

  buildInputs = [ libffi readline ];

  doCheck = true;

  buildPhase = ''
    make -C mpy-cross
    make -C ports/unix
  '';

  checkPhase = ''
    pushd tests
    MICROPY_MICROPYTHON=../ports/unix/micropython ${python3.interpreter} ./run-tests
    popd
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 ports/unix/micropython $out/bin/micropython
  '';

  meta = with lib; {
    description = "A lean and efficient Python implementation for microcontrollers and constrained systems";
    homepage = "https://micropython.org";
    platforms = [ "x86_64-linux" ];
    license = licenses.mit;
    maintainers = with maintainers; [ sgo ];
  };
}
