{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "argp-standalone";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "ericonr";
    repo = "argp-standalone";
    rev = version;
    sha256 = "sha256-6efNmFalvMo2AYfNV5jmCc9xy8BCyvrx39Bbtt8gthc=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = ''
    install -D libargp.a $out/lib/libargp.a
    install -D argp.h $out/include/argp.h
  '';

  doCheck = true;

  makeFlags = [ "AR:=$(AR)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.lysator.liu.se/~nisse/misc/";
    description = "Standalone version of arguments parsing functions from GLIBC";
    platforms = with platforms; darwin ++ linux;
    maintainers = with maintainers; [ amar1729 ];
    license = licenses.gpl2;
  };
}
