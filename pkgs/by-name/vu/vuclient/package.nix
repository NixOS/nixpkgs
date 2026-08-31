{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "vuclient";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "bonds";
    repo = "vuclient";
    rev = "v${version}";
    hash = "sha256-L8TMHIA2WaYyF9Uv295ygZ5LJRaf9zRhRRHrD5WpVBE=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src/vuclient $out/bin/vuclient
    chmod +x $out/bin/vuclient
  '';

  meta = with lib; {
    description = "A script that samples perf stats and sends them to a vuserver driving VU1 dials.";
    homepage = "https://github.com/bonds/vuclient/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bonds ];
  };
}
