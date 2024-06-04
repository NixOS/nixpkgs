{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  nose,
}:

buildPythonPackage rec {
  pname = "nose-warnings-filters";
  version = "0.1.5";
  format = "setuptools";

  src = fetchPypi {
    pname = "nose_warnings_filters";
    inherit version;
    sha256 = "17dvfqfy2fm7a5cmiffw2dc3064kpx72fn5mlw01skm2rhn5nv25";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ nose ];

  nativeCheckInputs = [ nose ];
  checkPhase = ''
    nosetests -v
  '';

  meta = {
    description = "Allow injecting warning filters during nosetest";
    homepage = "https://github.com/Carreau/nose_warnings_filters";
    license = lib.licenses.mit;
  };
}
