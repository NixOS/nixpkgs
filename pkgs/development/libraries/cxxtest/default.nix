{ lib, buildPythonApplication, fetchFromGitHub, ply }:

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

  propagatedBuildInputs = [
    ply
  ];

  postCheck = ''
    python scripts/cxxtestgen --error-printer -o python3/build/GoodSuite.cpp ../test/GoodSuite.h
    $CXX -I.. -o python3/build/GoodSuite python3/build/GoodSuite.cpp
    python3/build/GoodSuite
  '';

  preInstall = ''
    pushd python3
  '';

  postInstall = ''
    popd
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
