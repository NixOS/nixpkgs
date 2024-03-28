{ llvmPackages
, lib
, fetchFromGitHub
, cmake
, python3
, curl
, libxml2
, libffi
, xar
}:

llvmPackages.stdenv.mkDerivation rec {
  pname = "c3c";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "c3lang";
    repo = pname;
    rev = "3255183ee49cb903be1c66717d90f35cbcae7f82";
    sha256 = "1482l0c8crirzaxqq9aghbvfj7c1bbbvzcyspmbv8xbxhyl48zcm";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.lld
    curl
    libxml2
    libffi
  ] ++ lib.optionals llvmPackages.stdenv.isDarwin [
    xar
  ];

  nativeCheckInputs = [ python3 ];

  doCheck = true;

  checkPhase = ''
    ( cd ../resources/testproject; ../../build/c3c build )
    ( cd ../test; python src/tester.py ../build/c3c test_suite )
  '';

  installPhase = ''
    install -Dm755 c3c $out/bin/c3c
    cp -r lib $out
  '';

  patches = [
    ./add_ldd_link.patch
  ];

  cmakeFlags = [
    "-DC3_LINK_DYNAMIC=0"
    "-DLLD_LIB_PATH=${llvmPackages.lld.lib}/lib"
  ];

  meta = with lib; {
    description = "Compiler for the C3 language";
    homepage = "https://github.com/c3lang/c3c";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
  };
}
