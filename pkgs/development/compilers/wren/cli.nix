{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, python3
}:
stdenv.mkDerivation rec {
  pname = "wren-cli";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "wren-lang";
    repo = pname;
    rev = version;
    sha256 = "sha256-AUb17rV07r00SpcXAOb9PY8Ea2nxtgdZzHZdzfX5pOA=";
  };

  patches = [
    # otherwise fails to build
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/wren-lang/wren-cli/pull/136.patch";
      sha256 = "sha256-/c1vbc769U/WeLGZiEdnALaooOHQcpTybfbxz+KQYUM=";
    })
  ];

  buildInputs = [ python3 ];

  buildPhase = ''
    make --directory projects/make
  '';

  doCheck = true;

  # NOTE: there is one test that depends on the realpath of $HOME.
  checkPhase = ''
    export HOME=$(mktemp -d)
    echo "======== Testing Wren CLI ========"

    python3 util/test.py
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv bin/wren_cli $out/bin/wren
  '';

  meta = with lib; {
    description = "A command line tool for the Wren programming language";
    homepage = "https://github.com/wren-lang/wren-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
