{ stdenv, fetchFromGitHub, coreutils, autoreconfHook, smlnj }:

let
  rev= "f8e08c89dd98b7b8dba318d245dcd4abd3328ae2";
in stdenv.mkDerivation rec {
  name = "manticore-${version}";
  version = "2017.08.22";
 
  src = fetchFromGitHub {
    owner = "ManticoreProject";
    repo = "manticore";
    sha256 = "06icq0qdzwyzbsyms53blxpb9i26n2vn7ci8p9xvvnq687hxhr73";
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
