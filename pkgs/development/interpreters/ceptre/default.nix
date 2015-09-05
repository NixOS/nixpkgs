{ stdenv, fetchgit, mlton }:

stdenv.mkDerivation rec {
  name = "ceptre-2015-08-15";

  src = fetchgit {
    url = https://github.com/chrisamaphone/interactive-lp;
    rev = "cffca6943b6c9f47d064e26ddad92c2d8eb6f0f9";
    sha256 = "0filimwssb656330d9gc8299l44imc5qyaf967p03ypg5260xq0i";
  };

  nativeBuildInputs = [ mlton ];

  installPhase = ''
    mkdir -p $out/bin
    cp ceptre $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A linear logic programming language for modeling generative interactive systems";
    homepage = https://github.com/chrisamaphone/interactive-lp;
    maintainers = with maintainers; [ pSub ];
  };
}
