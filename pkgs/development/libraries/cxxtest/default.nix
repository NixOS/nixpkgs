{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "cxxtest";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "CxxTest";
    repo = pname;
    rev = version;
    sha256 = "19w92kipfhp5wvs47l0qpibn3x49sbmvkk91yxw6nwk6fafcdl17";
  };

  sourceRoot = "${src.name}/python";

  nativeCheckInputs = [ python3Packages.ply ];

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
    homepage = "http://cxxtest.com";
    description = "Unit testing framework for C++";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ juliendehos ];
  };
}
