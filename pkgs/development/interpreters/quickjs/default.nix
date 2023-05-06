{ lib
, stdenv
, fetchFromGitHub
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "quickjs";
  version = "2021-03-27";

  src = fetchFromGitHub {
    owner = "bellard";
    repo = pname;
    rev = "b5e62895c619d4ffc75c9d822c8d85f1ece77e5b";
    hash = "sha256-VMaxVVQuJ3DAwYrC14uJqlRBg0//ugYvtyhOXsTUbCA=";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile --replace "CONFIG_LTO=y" ""
  '';

  makeFlags = [ "prefix=${placeholder "out"}" ];
  enableParallelBuilding = true;

  nativeBuildInputs = [
    texinfo
  ];

  postBuild = ''
    (cd doc
     makeinfo *texi)
  '';

  postInstall = ''
    (cd doc
     install -Dt $out/share/doc *texi *info)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    PATH="$out/bin:$PATH"

    # Programs exit with code 1 when testing help, so grep for a string
    set +o pipefail
    qjs     --help 2>&1 | grep "QuickJS version"
    qjscalc --help 2>&1 | grep "QuickJS version"
    set -o pipefail

    temp=$(mktemp).js
    echo "console.log('Output from compiled program');" > "$temp"
    set -o verbose
    out=$(mktemp) && qjsc         -o "$out" "$temp" && "$out" | grep -q "Output from compiled program"
    out=$(mktemp) && qjsc   -flto -o "$out" "$temp" && "$out" | grep -q "Output from compiled program"
  '';

  meta = with lib; {
    description = "A small and embeddable Javascript engine";
    homepage = "https://bellard.org/quickjs/";
    maintainers = with maintainers; [ stesie AndersonTorres ];
    platforms = platforms.unix;
    license = licenses.mit;
    mainProgram = "qjs";
  };
}
