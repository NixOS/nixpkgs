{ llvmPackages
, stdenv
, lib
, fetchFromGitHub
, boost
}:

stdenv.mkDerivation rec {
  pname = "construct";
  version = "master";

  src = fetchFromGitHub {
    owner = "Thomas-de-Bock";
    repo = pname;
    rev = "b109a7f67253364af2c405506a461935c6c887b6";
    sha256 = "sha256-pOoqjtFkvMtof+YjV47JPu5tw/U6CU/MpL+C1Z1pgrE=";
  };

  buildInputs = [ boost ];

  buildPhase = ''
    make main
  '';

  installPhase = ''
    mkdir -p $out/
    cp -r bin $out/
  '';

  meta = with lib; {
    description = "Construct is an abstraction over x86 NASM Assembly";
    longDescription = "Construct adds features such as while loops, if statements, scoped macros and  function-call syntax to NASM Assembly.";
    homepage = "https://github.com/Thomas-de-Bock/construct";
    maintainers = with maintainers; [ rucadi ];
    platforms = platforms.all;
  };
}
