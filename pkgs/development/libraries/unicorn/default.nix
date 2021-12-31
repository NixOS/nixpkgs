{ lib, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, IOKit
}:

stdenv.mkDerivation rec {
  pname = "unicorn";
  version = "2.0.0-rc5";

  src = fetchFromGitHub {
    owner = "unicorn-engine";
    repo = pname;
    rev = version;
    sha256 = "1q9k8swnq4qsi54zdfaap69z56w3yj4n4ggm9pscmmmr69nply5f";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with lib; {
    description = "Lightweight multi-platform CPU emulator library";
    homepage = "http://www.unicorn-engine.org";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice luc65r ];
  };
}
