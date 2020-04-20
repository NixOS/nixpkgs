{ fetchFromGitHub, stdenv }:

stdenv.mkDerivation rec {
  pname = "MoonPlus";
  version = "0.3.8";
  src = fetchFromGitHub {
    owner = "pigpigyyy";
    repo = pname;
    rev = "v${version}";
    sha256 = "12wcw6zvm1a7hphjngy0hr6ywq1y9wpa9ssrryqv0ni4kamylqqr";
  };

  installPhase = ''
    install -D bin/release/moonp $out/bin/moonp
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/pigpigyyy/MoonPlus";
    description = "Moonscript to Lua compiler";
    license = licenses.mit;
    maintainers = with maintainers; [ xe ];
    platforms = platforms.all;
  };
}
