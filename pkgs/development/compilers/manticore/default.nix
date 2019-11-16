{ stdenv, fetchFromGitHub, coreutils, autoreconfHook, smlnj }:

let
  rev= "4528ccacdfd53d36f5959c005b27cd7ab6175b83";
in stdenv.mkDerivation {
  pname = "manticore";
  version = "2019.09.20";
 
  src = fetchFromGitHub {
    owner = "ManticoreProject";
    repo = "manticore";
    sha256 = "1xz7msiq5x2c56zjxydbxlj6r001mm5zszcda6f6v5qfmmd1bakz";
    inherit rev;
  };

  enableParallelBuilding = false;
 
  nativeBuildInputs = [ autoreconfHook ];
  
  buildInputs = [ coreutils smlnj ];

  autoreconfFlags = "-Iconfig -vfi";

  unpackPhase = ''
    mkdir -p $out
    cd $out
    unpackFile $src
    mv source repo_checkout
    cd repo_checkout
    chmod u+w . -R
  ''; 
  
  postPatch = ''
    patchShebangs .
    substituteInPlace configure.ac --replace 'MANTICORE_ROOT=`pwd`' 'MANTICORE_ROOT=$out/repo_checkout'
  '';

  preInstall = "mkdir -p $out/bin";

  meta = {
    description = "A parallel, pure variant of Standard ML";

    longDescription = '' 
      Manticore is a high-level parallel programming language aimed at
      general-purpose applications running on multi-core
      processors. Manticore supports parallelism at multiple levels:
      explicit concurrency and coarse-grain parallelism via CML-style
      constructs and fine-grain parallelism via various light-weight
      notations, such as parallel tuple expressions and NESL/Nepal-style
      parallel array comprehensions.  
    '';

    homepage = http://manticore.cs.uchicago.edu/;
  };
}
