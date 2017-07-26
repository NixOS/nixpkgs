{ stdenv, fetchFromGitHub, coreutils, autoreconfHook, smlnj }:

let
    rev = "592a5714595b4448b646a7d49df04c285668c2f8";
in stdenv.mkDerivation rec {
  name = "manticore-${version}";
  version = "2014.08.18";
 
  src = fetchFromGitHub {
    owner = "rrnewton";
    repo = "manticore_temp_mirror";
    sha256 = "1snwlm9a31wfgvzb80y7r7yvc6n0k0bi675lqwzll95as7cdswwi";
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
    mv manticore_temp_mirror-${rev}-src repo_checkout
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
