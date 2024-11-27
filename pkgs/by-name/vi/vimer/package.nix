{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.2.0";
  pname = "vimer";

  src = fetchFromGitHub {
    owner = "susam";
    repo = "vimer";
    rev = version;
    sha256 = "01qhr3i7wasbaxvms39c81infpry2vk0nzh7r5m5b9p713p0phsi";
  };

  installPhase = ''
    mkdir $out/bin/ -p
    cp vimer $out/bin/
    chmod +x $out/bin/vimer
  '';

  meta = with lib; {
    homepage = "https://github.com/susam/vimer";
    description = ''
      A convenience wrapper for gvim/mvim --remote(-tab)-silent to open files
      in an existing instance of GVim or MacVim.
    '';
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.all;
    mainProgram = "vimer";
  };

}

