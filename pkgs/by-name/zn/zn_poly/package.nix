{
  stdenv,
  lib,
  fetchFromGitLab,
  gmp,
  python3,
  tune ? false, # tune to hardware, impure
}:

stdenv.mkDerivation rec {
  version = "0.9.2";
  pname = "zn_poly";

  # sage has picked up the maintenance (bug fixes and building, not development)
  # from the original, now unmaintained project which can be found at
  # http://web.maths.unsw.edu.au/~davidharvey/code/zn_poly/
  src = fetchFromGitLab {
    owner = "sagemath";
    repo = "zn_poly";
    rev = version;
    hash = "sha256-QBItcrrpOGj22/ShTDdfZjm63bGW2xY4c71R1q8abPE=";
  };

  buildInputs = [
    gmp
  ];

  nativeBuildInputs = [
    python3 # needed by ./configure to create the makefile
  ];

  # name of library file ("libzn_poly.so")
  libbasename = "libzn_poly";
  libext = stdenv.hostPlatform.extensions.sharedLibrary;

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  # Tuning (either autotuning or with hand-written parameters) is possible
  # but not implemented here.
  # It seems buggy anyways (see homepage).
  buildFlags = [
    "all"
    "${libbasename}${libext}"
  ];

  configureFlags = lib.optionals (!tune) [
    "--disable-tuning"
  ];

  # `make install` fails to install some header files and the lib file.
  installPhase = ''
    mkdir -p "$out/include/zn_poly"
    mkdir -p "$out/lib"
    cp "${libbasename}"*"${libext}" "$out/lib"
    cp include/*.h "$out/include/zn_poly"
  '';

  doCheck = true;

  meta = with lib; {
    homepage = "https://web.maths.unsw.edu.au/~davidharvey/code/zn_poly/";
    description = "Polynomial arithmetic over Z/nZ";
    license = with licenses; [ gpl3 ];
    maintainers = teams.sage.members;
    platforms = platforms.unix;
  };
}
