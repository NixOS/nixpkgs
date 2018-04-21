{ stdenv, fetchFromGitHub, autoconf, automake, coq }:

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-HoTT-${version}";
  version = "20170921";

  src = fetchFromGitHub {
    owner = "HoTT";
    repo = "HoTT";
    rev = "e3557740a699167e6adb1a65855509d55a392fa1";
    sha256 = "0zwfp8g62b50vmmbb2kmskj3v6w7qx1pbf43yw0hr7asdz2zbx5v";
  };

  buildInputs = [ autoconf automake coq ];
  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs ./autogen.sh
    ./autogen.sh

    mkdir -p "$out/bin"
  '';

  configureFlags = [
    "--bindir=$(out)/bin"
  ];

  patchPhase = ''
    patchShebangs etc
    patchShebangs hoqc hoqchk hoqdep hoqide hoqtop
  '';

  postBuild = ''
    patchShebangs hoq-config
  '';

  # Currently, all the scripts like hoqc and hoqtop assume that the *.vo files are
  # either (1) in the same directory as the scripts, or (2) in /usr/share/hott.
  # We fulfill (1), which means that these files are only accessible via hoqtop,
  # hoqc, etc and not via coqtop, coqc, etc.
  postInstall = ''
    mv $out/share/hott/* "$out/bin"
    rmdir $out/share/hott
    rmdir $out/share
  '';

  installFlags = [
    "COQBIN=${coq}/bin"
  ];

  meta = with stdenv.lib; {
    homepage = http://homotopytypetheory.org/;
    description = "Homotopy type theory";
    maintainers = with maintainers; [ siddharthist ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: v == "8.6";
  };
}
