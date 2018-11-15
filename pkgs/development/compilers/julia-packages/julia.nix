{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "julia-binary-${version}";
  version = "1.0.2";

  src = fetchurl {
    url = "https://julialang-s3.julialang.org/bin/linux/x64/1.0/julia-1.0.2-linux-x86_64.tar.gz";
    sha256 = "0hpisary2n00vya6fxlfbzpkz2s82gi7lzgjsm3ari1wfm4kksg0";
  };

  /* dontBuild = true; */
  installPhase = ''
    cp -r . $out
  '';
  phases = ["unpackPhase" "installPhase"];

  meta = with stdenv.lib; {
    description = "The Julia Programming Language - binary distribution";
    homepage = https://julialang.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ tbenst ];
  };
}
