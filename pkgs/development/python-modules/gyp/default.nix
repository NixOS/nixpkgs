{ lib
, stdenv
, buildPythonPackage
, fetchFromGitiles
, six
, python
}:

buildPythonPackage {
  pname = "gyp";
  version = "unstable-2022-04-01";

  src = fetchFromGitiles {
    url = "https://chromium.googlesource.com/external/gyp";
    rev = "9ecf45e37677743503342ee4c6a76eaee80e4a7f";
    hash = "sha256-LUlF2VhRnuDwJLdITgmXIQV/IuKdx1KXQkiPVHKrl4Q=";
  };

  patches = lib.optionals stdenv.isDarwin [
    ./no-darwin-cflags.patch
    ./no-xcode.patch
  ];

  propagatedBuildInputs = [
    six
  ];

  pythonImportsCheck = [ "gyp" "gyp.generator" ];

  meta = with lib; {
    description = "A tool to generate native build files";
    homepage = "https://gyp.gsrc.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ codyopel ];
  };
}
