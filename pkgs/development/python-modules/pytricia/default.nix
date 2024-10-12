{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pytricia";
  version = "unstable-2019-01-16";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jsommers";
    repo = pname;
    rev = "4ba88f68c3125f789ca8cd1cfae156e1464bde87";
    sha256 = "0qp5774xkm700g35k5c76pck8pdzqlyzbaqgrz76a1yh67s2ri8h";
  };

  meta = with lib; {
    description = "Library for fast IP address lookup in Python";
    homepage = "https://github.com/jsommers/pytricia";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ mkg ];
  };
}
