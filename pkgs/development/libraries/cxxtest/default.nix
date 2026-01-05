{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  ply,
}:

buildPythonApplication rec {
  pname = "cxxtest";
  version = "4.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CxxTest";
    repo = "cxxtest";
    rev = version;
    sha256 = "19w92kipfhp5wvs47l0qpibn3x49sbmvkk91yxw6nwk6fafcdl17";
  };

  sourceRoot = "${src.name}/python";

  nativeCheckInputs = [ ply ];

  preCheck = ''
    cd ../
  '';

  postCheck = ''
    cd python3
    python scripts/cxxtestgen --error-printer -o build/GoodSuite.cpp ../../test/GoodSuite.h
    $CXX -I../../ -o build/GoodSuite build/GoodSuite.cpp
    build/GoodSuite
  '';

  preInstall = ''
    cd python3
  '';

  postInstall = ''
    mkdir -p "$out/include"
    cp -r ../../cxxtest "$out/include"
  '';

  dontWrapPythonPrograms = true;

  meta = with lib; {
    homepage = "https://github.com/CxxTest/cxxtest";
    description = "Unit testing framework for C++";
    mainProgram = "cxxtestgen";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ juliendehos ];
  };
}
