{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "concurrentqueue";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "cameron314";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wj5i2yvdapbmpjmn0pyk2c9v03194zckxa6n5g9havqlsby78gs";
  };

  # The makefile uses relative paths so setting makefile or makeFlags doesn't work.
  preBuild = ''
    cd build
  '';

  #_FORTIFY_SOURCE requires compiling with optimization (-O)
  NIX_CFLAGS_COMPILE = "-O";

  checkPhase = ''
    bin/unittests
  '';

  installPhase = ''
    mkdir -p $out/{lib,include}
    cp bin/libtbb.a $out/lib
    cp ../*.h $out/include
  '';

  meta = with lib; {
    description =
      "A fast multi-producer, multi-consumer lock-free concurrent queue for C++11";
    homepage = "https://github.com/cameron314/concurrentqueue";
    license = licenses.bsd3;
    maintainers = [ teams.deshaw.members ];
  };
}
