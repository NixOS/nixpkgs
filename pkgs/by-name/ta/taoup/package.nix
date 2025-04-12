{ lib, stdenv, fetchFromGitHub, ruby, bash, ncurses }:
let
  rubyEnv = ruby.withPackages (ps: with ps; [ ansi ]);
in
stdenv.mkDerivation rec {
  pname = "taoup";
  version = "1.1.23";

  src = fetchFromGitHub {
    owner = "globalcitizen";
    repo = "taoup";
    rev = "v${version}";
    hash = "sha256-9J46fKyeSZW71r67R8y9KVPeCH8fn27hOk/XpusqGmk=";
  };

  buildInputs = [ rubyEnv bash ncurses ];

  patches = [
    # Pre-create a cache within this derivation
    ./cachefile.patch
    # Remove the need to test for `tput`, depend on ncurses directly
    ./tput.patch
    # Fix the script name in `taoup --help` output
    ./help.patch
  ];

  postPatch = ''
    substituteInPlace taoup \
     --subst-var-by ncurses ${ncurses} \
     --subst-var-by pname taoup
    substituteInPlace taoup-fortune \
      --subst-var-by out $out \
      --replace-fail "/bin/bash" "${bash}/bin/bash"
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/taoup}

    cp taoup $out/lib/taoup
    cat > $out/bin/taoup <<EOF
    #!${bash}/bin/bash
    exec ${rubyEnv}/bin/ruby "$out/lib/taoup/taoup" "\$@"
    EOF
    chmod +x $out/bin/taoup

    # Populate the cache created by cachefile.patch above
    $out/bin/taoup > $out/lib/taoup/cache

    cp taoup-fortune $out/bin
    chmod +x $out/bin/taoup-fortune

    runHook postInstall
  '';

  meta = {
    description = "Tao of Unix Programming (Ruby-powered ANSI colored fortunes)";
    homepage = "https://github.com/globalcitizen/taoup";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.zakame ];
  };
}
