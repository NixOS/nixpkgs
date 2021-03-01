{ lib, stdenv, fetchFromGitHub, cmake, openmp }:

stdenv.mkDerivation rec {
  pname = "vid.stab";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "georgmartius";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a3frpm2kdbx7vszhg64p3alisag73bcspl7fp3a2f1kgq7rbh38";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.cc.isClang [ openmp ];

  meta = with lib; {
    description = "Video stabilization library";
    homepage = "http://public.hronopik.de/vid.stab/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ codyopel ];
    platforms = platforms.all;
  };
}
