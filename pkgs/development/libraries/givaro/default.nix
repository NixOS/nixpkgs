{stdenv, fetchFromGitHub, automake, autoconf, libtool, autoreconfHook, gmpxx}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "givaro";
  version = "4.0.2";
  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "04n1lyc823z3l1d7mnmqpc9z1pkn646szjchasbfkn74m7cb0qz7";
  };
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [autoconf automake libtool gmpxx];
  meta = {
    inherit version;
    description = ''A C++ library for arithmetic and algebraic computations'';
    license = stdenv.lib.licenses.cecill-b;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
