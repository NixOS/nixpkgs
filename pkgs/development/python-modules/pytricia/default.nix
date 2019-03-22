{ stdenv
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pytricia";
  version = "2019-01-16";

  src = fetchFromGitHub {
    owner = "jsommers";
    repo = "pytricia";
    rev = "4ba88f68c3125f789ca8cd1cfae156e1464bde87";
    sha256 = "0qp5774xkm700g35k5c76pck8pdzqlyzbaqgrz76a1yh67s2ri8h";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A library for fast IP address lookup in Python";
    homepage = https://github.com/jsommers/pytricia;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ mkg ];
  };
}
