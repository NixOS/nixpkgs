{ stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  name = "opentracing-cpp-${version}";
  version = "1.5.0";
  src = fetchFromGitHub {
    owner = "opentracing";
    repo = "opentracing-cpp";
    rev = "v${version}";
    sha256 = "09hxj59vvz1ncbx4iblgfc3b5i74hvb3vx5245bwwwfkx5cnj1gg";
  };
  buildInputs = [ cmake ];

  meta = {
    description = "C++ implementation of the OpenTracing API";
    homepage = http://opentracing.io;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ rob ];
  };

}

