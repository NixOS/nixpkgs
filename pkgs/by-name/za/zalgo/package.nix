{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "zalgo";
  version = "unstable-2020-08-26";

  src = fetchFromGitHub {
    owner = "lunasorcery";
    repo = "zalgo";
    rev = "6aa1f66cfe183f8164a666730dfeaf39133cf01a";
    sha256 = "00q56yvfcj2f89wllrckvizihivqmd6l77nihb52ffqd99rdd24w";
  };

  installPhase = ''
    install -Dm755 zalgo -t $out/bin
  '';

  meta = with lib; {
    description = "Read stdin and corrupt it with combining diacritics";
    homepage = "https://github.com/lunasorcery/zalgo";
    license = licenses.unfree;
    platforms = platforms.unix;
    maintainers = with maintainers; [ djanatyn ];
    mainProgram = "zalgo";
  };
}
