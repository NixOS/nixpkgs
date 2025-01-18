{
  buildPythonPackage,
  fetchPypi,
  lib,
  pandocfilters,
}:

buildPythonPackage rec {
  pname = "pandoc-attributes";
  version = "0.1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "69221502dac74f5df1317011ce62c85a83eef5da3b71c63b1908e98224304a8c";
  };

  propagatedBuildInputs = [ pandocfilters ];

  # No tests in pypi source
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/aaren/pandoc-attributes";
    description = "Attribute class to be used with pandocfilters";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vcanadi ];
  };
}
