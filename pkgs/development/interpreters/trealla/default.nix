{ lib, stdenv, fetchFromGitHub, readline, openssl, libffi, valgrind, withThread ? true, withSSL ? true, xxd }:

stdenv.mkDerivation rec {
  pname = "trealla";
  version = "2.8.4";

  src = fetchFromGitHub {
    owner = "trealla-prolog";
    repo = "trealla";
    rev = "v${version}";
    sha256 = "sha256-/jB4jlYotvdU068+zj9Z+G0g75sI9dTmtgN874i0qAE=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace '-I/usr/local/include' "" \
      --replace '-L/usr/local/lib' "" \
      --replace 'GIT_VERSION :=' 'GIT_VERSION ?='
  '';

  makeFlags = [
    "GIT_VERSION=\"v${version}\""
    (lib.optionalString withThread "THREADS=1")
    (lib.optionalString (!withSSL) "NOSSL=1")
    (lib.optionalString stdenv.isDarwin "NOLDLIBS=1")
  ];

  nativeBuildInputs = [ xxd ];
  buildInputs = [ readline openssl libffi ];
  checkInputs = [ valgrind ];
  enableParallelBuilding = true;

  installPhase = ''
    install -Dm755 -t $out/bin tpl
  '';

  doCheck = true;
  preCheck = ''
    # Disable tests due to floating point error
    rm tests/issues-OLD/test081.pl
    rm tests/issues-OLD/test585.pl
    # Disable test due to Unicode issues
    rm tests/issues-OLD/test252.pl
  '';

  meta = with lib; {
    description = "A compact, efficient Prolog interpreter written in ANSI C";
    homepage = "https://github.com/trealla-prolog/trealla";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    mainProgram = "tpl";
    platforms = platforms.all;
  };
}
