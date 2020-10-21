{ stdenv
, buildPythonPackage
, fetchPypi
, pyvcf
}:

buildPythonPackage rec {
  pname = "ACEBinf";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1168pny671l6zfm2vv1pwspnflmzi7f4v8yldjl7zlz0b9cm5zlz";
  };

  buildInputs = [ pyvcf ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "acebinf" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/ACEnglish/acebinf";
    description = "Collection of simple utilities used when building bioinformatics tools";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ris ];
  };
}
