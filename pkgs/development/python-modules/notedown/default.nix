{ buildPythonPackage
, fetchPypi
, lib
, nbconvert
, nbformat
, notebook
, pandoc-attributes
, six
}:

buildPythonPackage rec {
  pname = "notedown";
  version = "1.5.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "36e033ebbbe5aca0fab031ffaf3611d5bc5c50237df68ff81bb95f8be353a1ee";
  };

  propagatedBuildInputs = [
    notebook
    nbconvert
    nbformat
    pandoc-attributes
    six
  ];

  # No tests in pypi source
  doCheck = false;

  meta = {
    homepage = "https://github.com/aaren/notedown";
    description = "Convert IPython Notebooks to markdown (and back)";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ vcanadi ];
  };
}
