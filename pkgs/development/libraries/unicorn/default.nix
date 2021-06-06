{ lib, stdenv
, fetchFromGitHub
, pkg-config
, cmake
}:

stdenv.mkDerivation rec {
  pname = "unicorn";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "unicorn-engine";
    repo = pname;
    rev = version;
    sha256 = "0jgnyaq6ykpbg5hrwc0p3pargmr9hpzqfsj6ymp4k07pxnqal76j";
  };

  nativeBuildInputs = [ pkg-config cmake ];

  meta = with lib; {
    description = "Lightweight multi-platform CPU emulator library";
    homepage = "http://www.unicorn-engine.org";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice luc65r ];
  };
}
