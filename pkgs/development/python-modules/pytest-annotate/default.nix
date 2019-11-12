{ stdenv
, buildPythonPackage
, fetchPypi
, pyannotate
, pytest
}:

buildPythonPackage rec {
  version = "1.0.3";
  pname = "pytest-annotate";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ef5924aca93a7b47edaf46a38284fb5a173eed5e3b1a93ec00c8e35f0dd76ab";
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

  meta = with stdenv.lib; {
    homepage = https://github.com/kensho-technologies/pytest-annotate;
    description = "Generate PyAnnotate annotations from your pytest tests";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
