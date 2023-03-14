{ lib, stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "janet";
  version = "1.27.0";

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UsM7J1LsiO5g3yxpO245Yr0oJQaCxs7LMNvxuHv6pTk=";
  };

  postPatch = ''
    substituteInPlace janet.1 \
      --replace /usr/local/ $out/
  '';

  nativeBuildInputs = [ meson ninja ];

  mesonFlags = [ "-Dgit_hash=release" ];

  doCheck = true;

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/janet -e '(+ 1 2 3)'
  '';

  meta = with lib; {
    description = "Janet programming language";
    homepage = "https://janet-lang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ andrewchambers peterhoeg ];
    platforms = platforms.all;
  };
}
