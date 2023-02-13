{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, unidecode
}:

buildPythonPackage rec {
  pname = "pyaml";
  version = "21.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6519fee13bf06e3bb3f20cacdea8eba9140385a7c2546df5dbae4887f768383";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  nativeCheckInputs = [
    unidecode
  ];

  pythonImportsCheck = [ "pyaml" ];

  meta = with lib; {
    description = "PyYAML-based module to produce pretty and readable YAML-serialized data";
    homepage = "https://github.com/mk-fg/pretty-yaml";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
  };
}
