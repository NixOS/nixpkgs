{ lib
, buildPythonPackage
, fetchPypi
, pyannotate
, pytest
}:

buildPythonPackage rec {
  version = "1.0.4";
  pname = "pytest-annotate";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d0da4c3d872a7d5796ac85016caa1da38ae902bebdc759e1b6c0f6f8b5802741";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    pyannotate
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest>=3.2.0,<4.0.0" "pytest"
  '';

  # no testing in a testing module...
  doCheck = false;

  meta = with lib; {
    broken = true; # unmaintained and incompatible with pytest>=6.0
    homepage = "https://github.com/kensho-technologies/pytest-annotate";
    description = "Generate PyAnnotate annotations from your pytest tests";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
