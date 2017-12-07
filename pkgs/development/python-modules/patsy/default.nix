{ lib
, fetchurl
, buildPythonPackage
, nose
, six
, numpy
, scipy
}:

buildPythonPackage rec {
  pname = "patsy";
  version = "0.4.1";

  src = fetchurl {
    url = "https://github.com/pydata/patsy/archive/v${version}.zip";
    sha256 = "1wkjd71rx1akfrk6iimi4zm783gagxmkxm3ppjyr2c98asni009c";
  };

  buildInputs = [ nose ];
  checkPhase = "nosetests -v";

  propagatedBuildInputs = [
    six
    numpy
  ] ++ lib.optional (!isNull scipy) [ scipy ];

  meta = {
    description = "A Python package for describing statistical models";
    homepage = "https://github.com/pydata/patsy";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ilya-kolpakov ];
  };
}

