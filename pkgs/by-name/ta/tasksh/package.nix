{
  lib,
  stdenv,
  fetchurl,
  cmake,
  readline,
}:

stdenv.mkDerivation rec {
  pname = "tasksh";
  version = "1.2.0";

  src = fetchurl {
    url = "https://taskwarrior.org/download/${pname}-${version}.tar.gz";
    sha256 = "1z8zw8lld62fjafjvy248dncjk0i4fwygw0ahzjdvyyppx4zjhkf";
  };

  buildInputs = [ readline ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # Fix the build with CMake 4.
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

<<<<<<< HEAD
  meta = {
    description = "REPL for taskwarrior";
    homepage = "http://tasktools.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "REPL for taskwarrior";
    homepage = "http://tasktools.org";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "tasksh";
  };
}
