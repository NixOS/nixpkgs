{
  lib,
  buildPythonPackage,
  fetchPypi,
  py,
  pytest,
}:

buildPythonPackage rec {
  pname = "pytest-raisesregexp";
  version = "2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b54372494fc1f11388b1b9348aeb36b69609699eb8f46e0e010afc733d78236a";
  };

  buildInputs = [
    py
    pytest
  ];

  # https://github.com/kissgyorgy/pytest-raisesregexp/pull/3
  prePatch = ''
    sed -i '3i\import io' setup.py
    substituteInPlace setup.py --replace "long_description=open('README.rst').read()," "long_description=io.open('README.rst', encoding='utf-8').read(),"
  '';

  meta = with lib; {
    description = "Simple pytest plugin to look for regex in Exceptions";
    homepage = "https://github.com/Walkman/pytest_raisesregexp";
    license = with licenses; [ mit ];
  };
}
