{ stdenv, fetchFromGitHub, libck, darwin }:

let
  version = "0.21";
  bootstrap = stdenv.mkDerivation {
    pname = "cyclone-bootstrap";
    inherit version;

    src = fetchFromGitHub {
      owner = "justinethier";
      repo = "cyclone-bootstrap";
      rev = "v${version}";
      sha256 = "0bb3a7x7vzmdyhm4nilm8bcn4q50pwqryggnxz21n16v6xakwjmr";
    };

    enableParallelBuilding = true;

    nativeBuildInputs = stdenv.lib.optionals stdenv.isDarwin [ darwin.cctools ];

    buildInputs = [ libck ];

    makeFlags = [ "PREFIX=${placeholder "out"}" ];
  };
in
stdenv.mkDerivation {
  pname = "cyclone";
  inherit version;

  src = fetchFromGitHub {
    owner = "justinethier";
    repo = "cyclone";
    rev = "v${version}";
    sha256 = "1vb4yaprs2bwbxmxx2zkqvysxx8r9qww2q1nqkz8yps3ji715jw7";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ bootstrap ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.cctools ];

  buildInputs = [ libck ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    homepage = "https://justinethier.github.io/cyclone/";
    description = "A brand-new compiler that allows practical application development using R7RS Scheme";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
