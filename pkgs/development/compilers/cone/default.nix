{ llvmPackages
, lib
, fetchFromGitHub
, cmake
}:

llvmPackages.stdenv.mkDerivation rec {
  pname = "cone";
  version = "unstable-2021-07-25";

  src = fetchFromGitHub {
    owner = "jondgoodwin";
    repo = pname;
    rev = "5feaabc342bcff3755f638a7e25155cd12127592";
    sha256 = "CTDS83AWtuDY5g6NDn7O2awrYsKFf3Kp35FkMEjfbVw=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    llvmPackages.llvm
  ];

  postPatch = ''
    sed -i CMakeLists.txt \
        -e 's/LLVM 7/LLVM/' \
        -e '/AVR/d'
  '';

  installPhase = ''
    install -Dm755 conec $out/bin/conec
    install -Dm644 libconestd.a $out/lib/libconestd.a
  '';

  meta = with lib; {
    description = "Cone Programming Language";
    homepage = "https://cone.jondgoodwin.com";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
  };
}
