{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pytricia";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nlhmnx2y3x17fcnspl4jargl1q9w8clwr8bqk32b6j5bbh0swy8";
  };

  # no tests in pypi, and no github releases
  doCheck = false;

  meta = with lib; {
    description = "A library for fast IP address lookup in Python";
    homepage = "https://github.com/jsommers/pytricia";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ mkg ];
  };
}
