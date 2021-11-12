{ lib
, stdenv
, buildPythonPackage
, pythonAtLeast
, fetchFromGitHub
, libarchive
, glibcLocales
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "libarchive-c";
  version = "3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Changaco";
    repo = "python-${pname}";
    rev = version;
    sha256 = "1z4lqy9zlzymshzrcldsc9ipys2l7grqg4yff6ndl6dgbfb0g4jb";
  };

  LC_ALL="en_US.UTF-8";

  postPatch = ''
    substituteInPlace libarchive/ffi.py --replace \
      "find_library('archive')" "'${libarchive.lib}/lib/libarchive${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  pythonImportsCheck = [
    "libarchive"
  ];

  checkInputs = [
    glibcLocales
    mock
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/Changaco/python-libarchive-c";
    description = "Python interface to libarchive";
    license = licenses.cc0;
  };

}
