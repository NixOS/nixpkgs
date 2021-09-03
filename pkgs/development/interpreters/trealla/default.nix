{ lib, stdenv, fetchFromGitHub, readline, openssl, withThread ? true, withSSL ? true, xxd }:

stdenv.mkDerivation rec {
  pname = "trealla";
  version = "1.9.37";

  src = fetchFromGitHub {
    owner = "infradig";
    repo = "trealla";
    rev = "v${version}";
    sha256 = "sha256-0cj4FGaYKIKCgWwRyLUw1DcvNnioQPOtqZhSvWSaojU=";
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
  buildInputs = [ readline openssl ];

  installPhase = ''
    install -Dm755 -t $out/bin tpl
  '';

  doCheck = true;
  preCheck = ''
    # Disable test 81 due to floating point error
    rm tests/issues/test081.expected tests/issues/test081.pl
  '';

  meta = with lib; {
    description = "A compact, efficient Prolog interpreter written in ANSI C";
    homepage = "https://github.com/infradig/trealla";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.all;
  };
}
