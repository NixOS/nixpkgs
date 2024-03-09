{ lib
, stdenv
, fetchFromGitHub
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "quickjs";
  version = "2021-12-09";

  src = fetchFromGitHub {
    owner = "bellard";
    repo = pname;
    rev = "daa35bc1e5d43192098af9b51caeb4f18f73f9f9";
    hash = "sha256-BhAsa8tumCQ4jK/TbRbptj2iOIUFFjU1MQYdIrDMpko=";
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
