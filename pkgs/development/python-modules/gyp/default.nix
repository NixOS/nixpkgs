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
  format = "setuptools";

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

  # Make mac_tool.py executable so that patchShebangs hook processes it. This
  # file is copied and run by builds using gyp on macOS
  preFixup = ''
    chmod +x "$out/${python.sitePackages}/gyp/mac_tool.py"
  '';

  meta = with lib; {
    description = "A tool to generate native build files";
    homepage = "https://gyp.gsrc.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ codyopel ];
  };
}
