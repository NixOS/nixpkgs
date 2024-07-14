{
  lib,
  fetchPypi,
  buildPythonPackage,
  six,
  wheel,
}:

buildPythonPackage rec {
  pname = "astunparse";
  version = "1.6.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Wtk6hFbw0ITDRW0Fn9mpLM5meWMjLL92Pqw7xbeUCHI=";
  };

  propagatedBuildInputs = [
    six
    wheel
  ];

  # tests not included with pypi release
  doCheck = false;

  meta = with lib; {
    description = "This is a factored out version of unparse found in the Python source distribution";
    homepage = "https://github.com/simonpercivall/astunparse";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyp ];
  };
}
