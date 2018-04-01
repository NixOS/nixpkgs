{ stdenv, buildPythonPackage, fetchPypi
, py, pytest }:

buildPythonPackage rec {
  pname = "pytest-raisesregexp";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q8yby4g3il86rp7rhk89792wm17cykzsqcwbxpbbyal3an8mphg";
  };

  buildInputs = [ py pytest ];

  # https://github.com/kissgyorgy/pytest-raisesregexp/pull/3
  prePatch = ''
    sed -i '3i\import io' setup.py
    substituteInPlace setup.py --replace "long_description=open('README.rst').read()," "long_description=io.open('README.rst', encoding='utf-8').read(),"
  '';

  meta = with stdenv.lib; {
    description = "Simple pytest plugin to look for regex in Exceptions";
    homepage = https://github.com/Walkman/pytest_raisesregexp;
    license = with licenses; [ mit ];
  };
}
