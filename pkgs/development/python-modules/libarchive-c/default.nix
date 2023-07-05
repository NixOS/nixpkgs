{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, libarchive
, glibcLocales
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "libarchive-c";
  version = "5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Changaco";
    repo = "python-${pname}";
    rev = "refs/tags/${version}";
    sha256 = "sha256-8e3Tnek5q5NJneSVIrbFNTQPjHZ7Ieb14uiKjQwufTE=";
  };

  LC_ALL="en_US.UTF-8";

  postPatch = ''
    substituteInPlace libarchive/ffi.py --replace \
      "find_library('archive')" "'${libarchive.lib}/lib/libarchive${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  pythonImportsCheck = [
    "libarchive"
  ];

  nativeCheckInputs = [
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
