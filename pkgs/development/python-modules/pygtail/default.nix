{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pygtail";
  version = "0.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bgreenlee";
    repo = pname;
    rev = version;
    sha256 = "1f8qlijiwn10jxg1bsi6q42fznbg8rw039yaxfh6rzbaj2gaxbz1";
  };

  # remove at next bump, tag is one commit early for 0.8.0
  postPatch = ''
    substituteInPlace pygtail/core.py \
      --replace 0.7.0 0.8.0
  '';

  meta = with lib; {
    description = "A library for reading log file lines that have not been read";
    mainProgram = "pygtail";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/bgreenlee/pygtail";
  };
}
