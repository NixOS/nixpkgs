{ stdenv
, buildPythonPackage
, fetchPypi
, html5lib
}:

buildPythonPackage rec {
  pname = "mechanize";
  version = "0.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6355c11141f6d4b54a17fc2106944806b5db2711e60b120d15d83db438c333fd";
  };

  propagatedBuildInputs = [ html5lib ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Stateful programmatic web browsing in Python";
    homepage = "https://github.com/python-mechanize/mechanize";
    license = "BSD-style";
  };

}
