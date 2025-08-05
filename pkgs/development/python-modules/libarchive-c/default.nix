{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  libarchive,
  glibcLocales,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "libarchive-c";
  version = "5.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Changaco";
    repo = "python-${pname}";
    tag = version;
    sha256 = "sha256-JqXTV1aD3k88OlW+8rT3xsDuW34+1xErG7hkupvL7Uo=";
  };

  LC_ALL = "en_US.UTF-8";

  postPatch = ''
    substituteInPlace libarchive/ffi.py --replace-fail \
      "find_library('archive')" "'${libarchive.lib}/lib/libarchive${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  pythonImportsCheck = [ "libarchive" ];

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
