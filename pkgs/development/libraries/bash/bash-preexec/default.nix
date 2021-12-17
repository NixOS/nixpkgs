{ stdenvNoCC, lib, fetchFromGitHub, bats }:

let version = "0.4.1";
in stdenvNoCC.mkDerivation {
  pname = "bash-preexec";
  inherit version;

  src = fetchFromGitHub {
    owner = "rcaloras";
    repo = "bash-preexec";
    rev = version;
    sha256 = "062iigps285628p710i7vh7kmgra5gahq9qiwj7rxir167lg0ggw";
  };

  checkInputs = [ bats ];

  dontConfigure = true;
  doCheck = true;
  dontBuild = true;

  patchPhase = ''
    # Needed since the tests expect that HISTCONTROL is set.
    sed -i '/setup()/a HISTCONTROL=""' test/bash-preexec.bats

    # Skip tests failing with Bats 1.5.0.
    # See https://github.com/rcaloras/bash-preexec/issues/121
    sed -i '/^@test.*IFS/,/^}/d' test/bash-preexec.bats
  '';

  checkPhase = ''
    bats test
  '';

  installPhase = ''
    install -Dm755 $src/bash-preexec.sh $out/share/bash/bash-preexec.sh
  '';

  meta = with lib; {
    description = "preexec and precmd functions for Bash just like Zsh";
    license = licenses.mit;
    homepage = "https://github.com/rcaloras/bash-preexec";
    maintainers = [ maintainers.hawkw maintainers.rycee ];
    platforms = platforms.unix;
  };
}
