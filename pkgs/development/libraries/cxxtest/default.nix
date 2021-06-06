{ lib, buildPythonApplication, fetchFromGitHub }:

buildPythonApplication rec {
  pname = "cxxtest";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "CxxTest";
    repo = pname;
    rev = version;
    sha256 = "19w92kipfhp5wvs47l0qpibn3x49sbmvkk91yxw6nwk6fafcdl17";
  };

  sourceRoot = "source/python";

  postCheck = ''
    python scripts/cxxtestgen --error-printer -o build/GoodSuite.cpp ../test/GoodSuite.h
    $CXX -I.. -o build/GoodSuite build/GoodSuite.cpp
    build/GoodSuite
  '';

  postInstall = ''
    mkdir -p "$out/include"
    cp -r ../cxxtest "$out/include"
  '';

  dontWrapPythonPrograms = true;

  meta = with lib; {
    homepage = "http://cxxtest.com";
    description = "Unit testing framework for C++";
    platforms = platforms.unix;
    license = licenses.lgpl3;
    maintainers = [ maintainers.juliendehos ];
  };
}
