{ stdenv, lib, makeWrapper, dev_only_shellcheck ? null,
fetchFromGitHub,

fzf, coreutils, libxml2, libxslt, jing, findutils, gnugrep, gnused,
docbook5
}:
stdenv.mkDerivation rec {
  pname = "xmloscopy";
  version = "0.1.3";

  nativeBuildInputs = [
    makeWrapper
    dev_only_shellcheck
  ];

  spath = lib.makeBinPath [
    fzf
    coreutils
    libxml2
    libxslt
    jing
    findutils
    gnugrep
    gnused
  ];

  src = fetchFromGitHub {
    owner = "grahamc";
    repo = "xmloscopy";
    rev = "v${version}";
    sha256 = "06y5bckrmnq7b5ny2hfvlmdws910jw3xbw5nzy3bcpqsccqnjxrc";
  };

  installPhase = ''
    sed -i "s/hard to say/v${version}/" ./xmloscopy
    type -P shellcheck && shellcheck ./xmloscopy
    chmod +x ./xmloscopy
    patchShebangs ./xmloscopy
    mkdir -p $out/bin
    cp ./xmloscopy $out/bin/
    wrapProgram $out/bin/xmloscopy \
      --set RNG "${docbook5}/xml/rng/docbook/docbook.rng" \
      --set PATH "${spath}"
  '';

  meta = with lib; {
    description = "wtf is my docbook broken?";
    mainProgram = "xmloscopy";
    homepage = "https://github.com/grahamc/xmloscopy";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ grahamc ];
  };
}
