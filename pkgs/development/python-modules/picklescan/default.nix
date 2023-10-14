{ buildPythonPackage
, fetchPypi
, setuptools
, isPy27
}:

buildPythonPackage rec {
  pname = "picklescan";
  version = "0.0.7";
  disabled = isPy27;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5HFpf+VPVIL/IvGDpOP9q0pdleNshiSW3QffX8qJVAk=";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  doCheck = false;

  meta = {
    description = "Security scanner detecting Python Pickle files performing suspicious actions";
    homepage = "https://github.com/mmaitre314/picklescan";
  };
}
