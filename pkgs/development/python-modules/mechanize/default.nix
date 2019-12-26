{ stdenv
, buildPythonPackage
, fetchPypi
, html5lib
}:

buildPythonPackage rec {
  pname = "mechanize";
  version = "0.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fff89e973bdf1aee75a351bd4dde53ca51a7e76944ddeae3ea3b6ad6c46045c";
  };

  propagatedBuildInputs = [ html5lib ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Stateful programmatic web browsing in Python";
    homepage = "https://github.com/python-mechanize/mechanize";
    license = "BSD-style";
  };

}
