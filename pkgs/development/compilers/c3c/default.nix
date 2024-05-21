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
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "c3lang";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-iOljE1BRVc92NJZj+nr1G6KkBTCwJEUOadXHUDNoPGk=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${LLVM_LIBRARY_DIRS}" "${llvmPackages.lld.lib}/lib ${llvmPackages.llvm.lib}/lib"
  '';

  nativeBuildInputs = [
    cmake
  ];

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

  doCheck = llvmPackages.stdenv.system == "x86_64-linux";

  checkPhase = ''
    runHook preCheck
    ( cd ../resources/testproject; ../../build/c3c build )
    ( cd ../test; python src/tester.py ../build/c3c test_suite )
    runHook postCheck
  '';

  meta = with lib; {
    description = "Compiler for the C3 language";
    homepage = "https://github.com/c3lang/c3c";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
  };
}
