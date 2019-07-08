{ stdenv, fetchFromGitHub, coreutils, autoreconfHook, smlnj }:

let
  rev= "47273c463fc3c5d0a0ae655cf75a4700bdb020b4";
in stdenv.mkDerivation rec {
  name = "manticore-${version}";
  version = "2018.09.29";
 
  src = fetchFromGitHub {
    owner = "ManticoreProject";
    repo = "manticore";
    sha256 = "1prrgp7ldkdnrdbj224qqkirw8bj72460ix97c96fy264j9c97cn";
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
