{ buildPythonPackage
, fetchPypi
, lib
, pandocfilters
}:

buildPythonPackage rec {
  pname = "pandoc-attributes";
  version = "0.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "69221502dac74f5df1317011ce62c85a83eef5da3b71c63b1908e98224304a8c";
  };

  propagatedBuildInputs = [
    pandocfilters
  ];

  # No tests in pypi source
  doCheck = false;

  meta = {
    homepage = https://github.com/aaren/pandoc-attributes;
    description = "An Attribute class to be used with pandocfilters";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ vcanadi ];
  };
}
