{ stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation {
  name = "opentracing-cpp";
  src = fetchFromGitHub {
    owner = "opentracing";
    repo = "opentracing-cpp";
    rev = "v1.5.0";
    sha256 = "09hxj59vvz1ncbx4iblgfc3b5i74hvb3vx5245bwwwfkx5cnj1gg";
  };
  buildInputs = [ cmake ];
}

