{ lib, stdenv, fetchFromGitHub, python }:

stdenv.mkDerivation rec {
  pname = "scalyr";
  version = "git-20190628";

  src = fetchFromGitHub {
    owner = "scalyr";
    repo = "scalyr-tool";
    rev = "9f6e6e7ddb6db3c19614e315f46d042852722a08"; # not tagged in repository
    sha256 = "1a90wwkisrpaqwd0pl88czgqdpjxig8j1m9yscyz9cx2n324zhbp";
  };

  dontBuild = true;
  
  buildInputs = [ python ];

  installPhase = ''
    mkdir -p "$out/bin/"
    cp scalyr $out/bin/
    chmod +x $out/bin/scalyr
  '';

  meta = with lib; {
    description = "CLI tool for scalyr service";
    homepage = "https://github.com/scalyr/scalyr-tool";
    license = licenses.asl20;
    maintainers = [ maintainers.mog ];
  };
}
