{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "yaml-cpp";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "jbeder";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "16lclpa487yghf9019wymj419wkyx4795wv9q7539hhimajw9kpb";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A YAML parser and emitter in C++ ";
    homepage = "https://github.com/jbeder/yaml-cpp";
    maintainers = with maintainers; [ spacekookie ];
  };
}
