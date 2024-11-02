{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pygtail";
  version = "0.14.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bgreenlee";
    repo = pname;
    rev = version;
    sha256 = "sha256-TlXTlxeGDd+elGpMjxcJCmRuJmp5k9xj6MrViRzcST4=";
  };


  meta = with lib; {
    description = "Library for reading log file lines that have not been read";
    mainProgram = "pygtail";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/bgreenlee/pygtail";
  };
}
