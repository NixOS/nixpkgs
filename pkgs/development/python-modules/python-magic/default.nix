{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, file
, pytestCheckHook
, glibcLocales
}:

buildPythonPackage rec {
  pname = "python-magic";
  version = "0.4.20";

  src = fetchFromGitHub {
    owner = "ahupp";
    repo = pname;
    rev = version;
    sha256 = "1zk9jqzfnkgmizislyb8nq6vvikylaybf1rrgd25pn8d4sf5iqp0";
  };

  propagatedBuildInputs = [ file ];

  postPatch = ''
    substituteInPlace magic/__init__.py --replace "ctypes.util.find_library('magic')" "'${file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  checkInputs = [ pytestCheckHook glibcLocales ];

  preCheck = ''
    export LC_ALL=en_US.UTF-8
  '';

  pytestFlagsArray = [ "test/test.py" ];

  pythonImportsCheck = [ "magic" ];

  meta = with lib; {
    description = "Python interface to the libmagic file type identification library";
    homepage = "https://github.com/ahupp/python-magic";
    license = licenses.mit;
  };
}

