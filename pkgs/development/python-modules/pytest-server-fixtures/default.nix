{ stdenv, buildPythonPackage, fetchPypi
, pytest, setuptools-git, pytest-shutil, pytest-fixture-config, psutil
, requests}:

buildPythonPackage rec {
  pname = "pytest-server-fixtures";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gs9qimcn8q6xi9d6i5624l0dziwvn6nj2rda07fg15g1cq66s8l";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ setuptools-git pytest-shutil pytest-fixture-config psutil requests ];

  # RuntimeError: Unable to find a free server number to start Xvfb
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Extensible server fixures for py.test";
    homepage  = "https://github.com/manahl/pytest-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
  };
}
