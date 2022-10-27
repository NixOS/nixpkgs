{ fetchFromGitHub, lib, stdenv, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "dotconf";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "williamh";
    repo = "dotconf";
    rev = "v${version}";
    sha256 = "1sc95hw5k2xagpafny0v35filmcn05k1ds5ghkldfpf6xw4hakp7";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  meta = with lib; {
    description = "A configuration parser library";
    maintainers = with maintainers; [ pSub ];
    homepage = "https://github.com/williamh/dotconf";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
  };
}
