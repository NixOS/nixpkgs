{ stdenv, fetchFromGitHub, bap, ocaml, findlib, ctypes, autoreconfHook,
  which }:

stdenv.mkDerivation rec {
  name = "libbap-${version}";
  version = "master-2019-04-05";

  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "bap-bindings";
    rev = "1a89db62f1239a15d310b400f74e151c0a64f37f";
    sha256 = "0mln9adjgxzhjmjayq06ahgiay4vj5kmnzdxqz3nsik9h3npycd6";
  };

  nativeBuildInputs = [ autoreconfHook which ];
  buildInputs = [ ocaml bap findlib ctypes ];

  preInstall = ''
    mkdir -p $out/lib
    mkdir -p $out/include
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/binaryanalysisplatform/bap-bindings;
    description = "A C library for interacting with BAP";
    maintainers = [ maintainers.maurer ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
