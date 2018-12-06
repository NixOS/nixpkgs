{ stdenv
, buildPythonPackage
, fetchPypi
, robotframework
, selenium
, docutils
, decorator
}:

buildPythonPackage rec {
  version = "1.6.0";
  pname = "robotframework-selenium2library";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1asdwrpb4s7q08bx641yrh3yicgba14n3hxmsqs58mqf86ignwly";
  };

  # error: invalid command 'test'
  #doCheck = false;

  propagatedBuildInputs = [ robotframework selenium docutils decorator ];

  meta = with stdenv.lib; {
    description = "Web testing library for Robot Framework";
    homepage = http://robotframework.org/;
    license = licenses.asl20;
  };

}
